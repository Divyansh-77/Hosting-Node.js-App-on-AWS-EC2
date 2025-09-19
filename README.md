# Stripe Payment Demo: Deployed on AWS EC2



This project is a simple Node.js application demonstrating Stripe integration for payments. It is deployed and running on an Amazon Web Services (AWS) EC2 instance.



## 🚀 Live Demo



You can view the live application here: **[http://107.20.29.29:3000](http://107.20.29.29:3000)**



![Live Application Screenshot]https://github.com/Divyansh-77/Hosting-Node.js-App-on-AWS-EC2/blob/3a5816ba8cd242885800128c8454591c32fb9cdb/Screenshot%20from%202025-09-19%2011-04-38.png



## 🛠️ Core Technologies



- **Backend:** Node.js, Express.js

- **Payments:** Stripe API

- **Deployment:** AWS EC2 (Ubuntu), PM2

- **Package Manager:** npm



---



## 1. Running the Project Locally



### Prerequisites



- Node.js and npm installed on your local machine

- A Stripe account to get API keys



### Setup Steps



#### 1. Clone the Repository



```bash

git clone https://github.com/verma-kunal/AWS-Session.git

cd AWS-Session

```



#### 2. Create a `.env` File



Create a `.env` file in the root directory with the following variables:



```env

DOMAIN="http://localhost"

PORT=3000

STATIC_DIR="./client"

# Get these from your Stripe Dashboard

PUBLISHABLE_KEY=pk_your_publishable_key

SECRET_KEY=sk_your_secret_key

```



#### 3. Install Dependencies and Start the Server



```bash

npm install

npm run start

```



#### 4. Access the Application



Open your browser and navigate to:



```

http://localhost:3000

```



---



## 2. Deployment to AWS EC2



These steps outline how this project was deployed to a live server.



### 1. Launch & Configure EC2 Instance



- **Instance Type:** t2.micro (Free Tier eligible)

- **Operating System (AMI):** Ubuntu Server

- **Key Pair:** Create and download a `.pem` file for SSH access

- **Security Group:** Create a new security group. Initially, only allow SSH (Port 22). Add an app rule later.

- **Elastic IP:** Allocate and associate with your EC2 instance for a static public IP address.



### 2. Connect and Prepare the Server



SSH into your instance:



```bash

ssh -i /path/to/your-key.pem ubuntu@<YOUR_ELASTIC_IP>

```



Update packages and install dependencies:



```bash

sudo apt update && sudo apt upgrade -y

sudo apt install -y nodejs npm git

```



### 3. Deploy the Application



Clone your project onto the EC2 instance:



```bash

git clone https://github.com/verma-kunal/AWS-Session.git

cd AWS-Session

```



Create the `.env` file on the server. Use your Elastic IP for the `DOMAIN` variable.



```env

DOMAIN="http://<YOUR_ELASTIC_IP>"

PORT=3000

STATIC_DIR="./client"

PUBLISHABLE_KEY=pk_your_publishable_key

SECRET_KEY=sk_your_secret_key

```



Install project dependencies:



```bash

npm install

```



### 4. Configure Security Group



- In the AWS EC2 Console, go to your instance's Security Group.

- Edit Inbound rules.

- Add a new rule:

  - **Type:** Custom TCP

  - **Port Range:** 3000

  - **Source:** Anywhere (0.0.0.0/0)



This allows public traffic to reach your application on port 3000.



### 5. Run the Application with PM2



We use [PM2](https://pm2.keymetrics.io/), a process manager for Node.js, to keep the application running forever, even after closing the terminal or server reboot.



Install PM2 globally:



```bash

sudo npm install pm2 -g

```



Start your app using PM2:



```bash

pm2 start "npm run start" --name "stripe-app"

```



Check if the app is running:



```bash

pm2 list

```



You should now be able to access your application at:



```

http://<YOUR_ELASTIC_IP>:3000

```



---



## 📚 About This Project



This project was deployed as my first hands-on experience with the AWS cloud. The goal was to understand the end-to-end process of taking a local Node.js application and making it publicly available on the internet through an EC2 instance.
