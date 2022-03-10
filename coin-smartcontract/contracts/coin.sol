// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0; // declare our liscenes and solidity version in lines 1 and 2
import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; //importing the ERC20 library from OpenZepplin
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol"; // inheriting the burn() function from ERC20Burnable to burn an excessive supply of our tokens if we needed to.

contract MemeCoin is ERC20, Ownable, ERC20Burnable { // lines 8 through 10, we set up a Solidity event which lets us set up logging directly to the Ethereum blockchain.
    event tokensBurned(address indexed owner, uint256 amount, string message); //The indexed keyword is used for keywords that we want to use as a filter on the blockcahin.
    event tokensMinted(address indexed owner, uint256 amount, string message);
    event additionalTokensMinted(address indexed owner,uint256 amount,string message);

    constructor() ERC20("FoxCoin", "FXC") {//we're calling our ERC20 constructor which requires the name of our token and its ticker symbol as its parameters.
        _mint(msg.sender, 1000 * 10**decimals()); //pulling the _mint function from the ERC20 library which lets us mint our token and transfer it to ourselves via msg.sender.
        //In this case we're minting 1000 tokens but notice that we are using decimal() . This function allows us to create fractional amounts of our currency, in this case 18 decimal places just like wei. decimal() actually just returns the number 18, you can see that here. Alternatively, we could have just written  1000 * 10**18 but why not get a little fancy 🙂 Then finally we set up an emitter to log our action to the blockchain.
        emit tokensMinted(msg.sender, 1000 * 10**decimals(), "Initial supply of tokens minted.");
    } //Events are followed by an emitter which triggers the log to be saved. 

    //We create another mint function here in the event as there is a huge demand for our token and we want to add more supply. 
    function mint(address to, uint256 amount) public onlyOwner {
        //We're using the onlyOwner modifer here from the Ownable.sol library to restrict this action to the owner of the contract only. You can see this here. 
        //We could of course do a require check here but we get a ton out of the box with the Ownable library like the ability to transfer the ownership of our contract. 
        _mint(to, amount);
        //Then we end with an emiter to log that our tokens have been minted.
        emit additionalTokensMinted(msg.sender, amount, "Additional tokens minted.");
    }

    //Notice we're using the override specifier here in line 1. 
    //This is used because there's already a burn() function specified in ER20.sol 
    //and we want to overwrite that with the burn function in ERC20Burnable.sol. 
    function burn(uint256 amount) public override onlyOwner {
        _burn(msg.sender, amount);
        emit tokensBurned(msg.sender, amount, "Tokens burned.");
    }
}