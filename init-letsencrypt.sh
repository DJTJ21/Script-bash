#!bin/bash
if ![ -x "$(command -v docker-compose)" ]; then
  echo "Error : docker-compose is not installed" >&2
  exit 1 
fi
domains=(romuald.org www.romuald.org)
rsa_key=4096
data_path="./data/certbot"
email=""
stagging=0
if [ -d "$data_path" ]; then
  read -p "Existing data found for $domains. Continue and replace existing certificate? (y/N) " decision
  if [ "$decision" != "Y" && "$decision" != "y" ]; then
   exit 1
  fi
if [ ! -e "$data_path/conf/options-ssl-nginx.conf"] || [ ! -e "$data_path/conf/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "$data_path/conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$data_path/conf/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$data_path/conf/ssl-dhparams.pem"
  echo
fi
echo "### Creating dummy certificate for $domains ..."
path="/etc/letsencrypt/live/$domains"
mkdir -p "$data_path/conf/live/$domains"
docker compose run --rm --entrypoint "openssl -req -node -x509 -newkey rsa:$rsa_key -days 1 -keyout '$path/privkey.pem' -out '$path/fullchain.pem' -subj 'CN/=localhost'" certbot
echo
echo "##### Starting nginx ..."
docker compose up --force-recreate -d nginx
echo
echo "### Deleting dummy certificate for $domains ..."
docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/$domains && \
  rm -Rf /etc/letsencrypt/archive/$domains && \
  rm -Rf /etc/letsencrypt/renewal/$domains.conf" certbot
echo

echo "### Requesting Let's Encrypt certificate for $domains ..."
domain_args =""
for domain in ${domains[@]}; do
domain_args="doamin_args -d domain"
done
# Select appropriate email arg
case "$email" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="$email" ;;
esac
# Enable staging mode if needed

if [ "$stagging != "0" ]; then staging_arg="--staging"; fi

echo "################Generate certificate########################"

docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --force-renewal" certbot
echo

echo "### Reloading nginx ..."
docker-compose exec nginx nginx -s reload 
