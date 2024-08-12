
# Pets4life
## _The Best App For Pets, Ever_

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

Pets4life is an web-app, mobile-app for Pet management.

- Easily expandable
- Easy to manage
- ✨Magic ✨

## Features

- Register and Login account for pet owners
- Add new and Update pet status
- Purchase and Schedule pet services
- The facility owner reminds pet owners of Examination and Vaccination schedules
- Cashier Management


## Tech

Pets4life uses a number of open source projects to work properly:

- [ReactJS] - HTML enhanced for web apps!
- [Ace Editor] - awesome web-based text editor
- [markdown-it] - Markdown parser done right. Fast and easy to extend.
- [Twitter Bootstrap] - great UI boilerplate for modern web apps
- [Net 6-LTS] - evented I/O for the backend
- [WebAPI] - fast NET network app framework [@[microsoft\]
](https://dotnet.microsoft.com/en-us/apps/aspnet/apis)
- [Gulp] - the streaming build system
- [Flutter](https://flutter.dev/) - Mobile development


And of course Dillinger itself is open source with a [public repository][dill]
 on GitHub.

## Installation

Pets4life requires [Node.js](https://nodejs.org/) v18+ to run.

Install the dependencies and devDependencies and start the server.

```sh
cd pets4life-ui
npm i
npm start
```

For production environments...

```sh
cd pets4life-app
flutter clean
flutter run

```

## Plugins

Petslife is currently extended with the following plugins.
Instructions on how to use them in your own application are linked below.

| Plugin | README |
| ------ | ------ |
| Dropbox | [plugins/dropbox/README.md][PlDb] |
| GitHub | [plugins/github/README.md][PlGh] |
| Google Drive | [plugins/googledrive/README.md][PlGd] |
| OneDrive | [plugins/onedrive/README.md][PlOd] |
| Medium | [plugins/medium/README.md][PlMe] |
| Google Analytics | [plugins/googleanalytics/README.md][PlGa] |


## Docker

Dillinger is very easy to install and deploy in a Docker container.

By default, the Docker will expose port 8080, so change this within the
Dockerfile if necessary. When ready, simply use the Dockerfile to
build the image.

```sh
cd dillinger
docker build -t <youruser>/dillinger:${package.json.version} .
```

This will create the dillinger image and pull in the necessary dependencies.
Be sure to swap out `${package.json.version}` with the actual
version of Dillinger.

Once done, run the Docker image and map the port to whatever you wish on
your host. In this example, we simply map port 8000 of the host to
port 8080 of the Docker (or whatever port was exposed in the Dockerfile):

```sh
docker run -d -p 8000:8080 --restart=always --cap-add=SYS_ADMIN --name=dillinger <youruser>/dillinger:${package.json.version}
```

> Note: `--capt-add=SYS-ADMIN` is required for PDF rendering.

Verify the deployment by navigating to your server address in
your preferred browser.

```sh
127.0.0.1:8000
```

## License

MIT

**Free Software, Hell Yeah!**


## Get Started

### *Registration*
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/47cd8b82-207d-43ea-8582-5d6b0686c977" alt="Main screen" style="height: 200px; width:100px;"/>
➞ 
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/16dc229b-3d40-4a4d-af56-1cef44767322" alt="Resigtration screen" style="height: 200px; width:100px;"/>
➞ 
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/bc07245c-25f1-41bd-90dd-a6acc8747b00" alt="OTP screen" style="height: 200px; width:100px;"/>
➞ 
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/c1c61cd0-9181-4bc4-8359-30422d9c6fc2" alt="Pet1 screen" style="height: 200px; width:100px;"/>
➞ 
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/41494f20-b172-4c47-8af2-13839031feb5" alt="Pet2 screen" style="height: 200px; width:100px;"/>

### *Home*
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/d334c75c-6f3c-4192-a756-03e2fd4eee1e" alt="Home screen" style="height: 200px; width:100px;"/>
➞ 
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/a1f6d5cb-f121-4baf-9358-a0011ba0cca5" alt="Sidebar screen" style="height: 200px; width:100px;"/>
➞ 
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/5c72d40a-d986-42c0-9880-efd004eee55d" alt="Home2 screen" style="height: 200px; width:100px;"/>

### *Shop*
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/a872c828-7b35-4755-bf9a-98de08295eb1" alt="Shop1 screen" style="height: 200px; width:100px;"/>
➞ 
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/0a3fc75f-d68a-4580-a5c4-e646c09531b8" alt="Shop2 screen" style="height: 200px; width:100px;"/>
➞ 
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/7f3cd29e-d079-412c-9415-1876fa85bd00" alt="ProductDetail screen" style="height: 200px; width:100px;"/>
➞ 
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/238243b3-138f-474c-957b-19b35722eba0" alt="ServiceDetail screen" style="height: 200px; width:100px;"/>

### *Payment*

<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/a3332838-1b8c-434d-9b46-b874806cd65e" alt="Cart screen" style="height: 200px; width:100px;"/>
➞ 
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/18eb2d7e-eae3-4d66-919c-136e2fc730e4" alt="Checkout screen" style="height: 200px; width:100px;"/>

### *Pet Insight*

<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/3416c8ef-abd1-4a7e-9e7f-011197212aa4" alt="Insight1 screen" style="height: 200px; width:100px;"/>
➞ 
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/b236f171-b249-44ae-ac3d-19d16a74c6ce" alt="Insight2 screen" style="height: 200px; width:100px;"/>

### *Profile*

<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/ebe76ae9-bbf0-4879-8292-48d5cbfd5862" alt="Profile screen" style="height: 200px; width:100px;"/>
➞ 
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/2cbecc40-e684-4abe-8651-134d68476510" alt="Profile screen" style="height: 200px; width:100px;"/>
➞ 
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/d82e666e-651f-4d71-b8e6-e497660aa5df" alt="Profile screen" style="height: 200px; width:100px;"/>
➞
<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/a01b5274-85dd-466a-8f92-989f14d57b4f" alt="Profile screen" style="height: 200px; width:100px;"/>

## Staff/Admin

<img src="https://github.com/nhattpam/exe201-pets4life-3layers/assets/84137831/57939dba-7eed-413f-832e-500772a620e0" alt="Staff screen" style="height: 300px; width:500px;"/>
