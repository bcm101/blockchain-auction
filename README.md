# blockchain-auction

This is a basic auction implemented through blockchain technology. I plan to have implement future features such as including ML in some aspect to make a truly 'smart' contract.

## Installation

Use [git](https://git-scm.com/) to download the files using:

```bash
git clone [url]
```

or download the zip files.

## Truffle

download [Node and NPM](https://nodejs.org/en/) and install the following packages:

```bash
npm install -g truffle
npm install -g solc
```

solc is the compiler for solidity, and truffle is the suite needed for running a local blockchain network.

## Ganache

install [Ganache](https://trufflesuite.com/ganache/) in order to properly run the project as this was intended to be used with ganache to provide a visual of the accounts during testing.

## Compiling and running

First, one must open ganache and create a new Ganache workspace. It is easiest to simply quickstart a workspace and name it later. [Here](https://github.com/bcm101/blockchain-auction/blob/main/images/ganacheUI.png) is what my current workspace looks like in ganache. After you open a new workspace, you should see something that looks like [this](https://github.com/bcm101/blockchain-auction/blob/main/images/GanacheNewWorkSpace.png). Note that all these accounts should have 100.00 Etherium as nothing has been added or changed from this local network.

Next one should open the code to the file ```truffle-config.js``` where you will see an object being exported called network that looks like [this](https://github.com/bcm101/blockchain-auction/blob/main/images/truffleConfig.png). You should make sure this section will match the RPC server described in ganache in the top of the screen.

Next, one must open the console to the home directory of the project again and compile the contracts using truffle:

```bash
truffle compile
```

This will create a build folder which will have json representations of all contracts compiled.

Next, we can use upload our contracts to the local network provided by Ganache using:

```bash
truffle migrate
```

This will use the deployment settings described in ```2_auction_migration.js```, specifically we will deploy an auction that will last for 1 hour, and the test item being sold is my cat Luna (only for test purposes you can't have her). 

This will deploy this contract under the address of the first account listed in Ganache (you should notice that the first address has lost a slight amount of Etherium due to the cost of gas)

Now you have a local blockchain network for my auction smart contract!

to interact with this using web3js console type:

```bash
truffle console
```

## Truffle Console

Now that you have a console open, you can create an instance of the contract in question:

```javascript
const auction = await Auction.deployed()
```

To get a list of all accounts:

```javascript
const accounts = await web3.eth.getAccounts()
accounts
```

A method from the smart contract can be used in web3. Every method from the smart contract has set number of parameters, however web3 methods will accept one extra parameter at the end that will specify details about how the method should be handled.

```
{from: [which account is calling this method], 
value: [only for payable function, how much wei to send],
...}
```

The first account is default going to be the owner of the contract, so any functions labeled _ownerOnly will only be able to be called by account[0].
To specify a method to come from an account that isn't default, pass the aforementioned object with ```{from: [sepperate account]}``` 

### Making a bid:

```javascript
auction.createBid({from: accounts[1], value: web3.utils.toWei('3', 'ether')}
```

You should see the update in ganache, as the second account has just placed a bid of 3 ether.

### Withdrawing

Withdrawing can only be done after the auction has ended! By default an auction will take exactly 1 hour. An Auction can be ended earlier if the owner ends it using the endAuction method.

```javascript
auction.withdrawYourBid({from: accounts[1]}
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

