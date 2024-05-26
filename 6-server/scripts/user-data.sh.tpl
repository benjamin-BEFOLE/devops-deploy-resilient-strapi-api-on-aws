#!/bin/bash 

CWD="/home/strapi"

# Install packages
yum update -y && yum install -y tar gzip nodejs-18.* && npm install --global yarn

# Create user account for Strapi server
useradd -m -s /bin/bash strapi

# Get app code
cd $${CWD}
su - strapi -c "mkdir app/"

aws --version
su - strapi -c "aws s3 cp s3://${bucket_strapi_backend}/artefacts/strapi/app.tar.gz app/app.tar.gz"
su - strapi -c "tar -zxvf app/app.tar.gz -C app/"

# Get env variables
su - strapi -c "aws secretsmanager get-secret-value --secret-id ${api_secrets_id} --query \"SecretString\" --output text > app/.env"
su - strapi -c "echo \"DATABASE_SSL=false\" >> app/.env"
su - strapi -c "echo \"DATABASE_CLIENT=${database_client}\" >> app/.env"
su - strapi -c "echo \"DATABASE_PORT=${database_port}\" >> app/.env"
su - strapi -c "echo \"DATABASE_NAME=${database_name}\" >> app/.env"
su - strapi -c "echo \"DATABASE_USERNAME=${database_username}\" >> app/.env"
su - strapi -c "echo \"DATABASE_HOST=${database_host}\" >> app/.env"
su - strapi -c "echo \"DATABASE_PASSWORD=$(aws secretsmanager get-secret-value --secret-id ${database_password_id} --query \"SecretString\" --output text)\" >> app/.env"

# Define Strapi service
mkdir scripts/

cat << EOF > scripts/strapi-start.sh
${strapi_start_sh}
EOF
chmod +x scripts/strapi-start.sh

cat << EOF > /etc/systemd/system/strapi.service 
${strapi_service}
EOF

# Launch Strapi service
systemctl enable strapi.service
systemctl start strapi.service
