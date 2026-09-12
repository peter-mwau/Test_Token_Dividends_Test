pragma solidity 0.7.0;

import "./IERC20.sol";
import "./IMintableToken.sol";
import "./IDividends.sol";
import "./SafeMath.sol";

contract Token is IERC20, IMintableToken, IDividends {
  // ------------------------------------------ //
  // ----- BEGIN: DO NOT EDIT THIS SECTION ---- //
  // ------------------------------------------ //
  using SafeMath for uint256;
  uint256 public totalSupply;
  uint256 public decimals = 18;
  string public name = "Test token";
  string public symbol = "TEST";
  mapping (address => uint256) public balanceOf;
  // ------------------------------------------ //
  // ----- END: DO NOT EDIT THIS SECTION ------ //  
  // ------------------------------------------ //

  mapping (address => mapping (address => uint256)) private allowances;
  mapping (address => uint256) private dividends;
  mapping (address => uint256) private withdrawnDividends;
  mapping (address => bool) private isTokenHolder;
  address[] private tokenHolders;
  mapping (address => uint256) private tokenHolderIndices;

  function _addTokenHolder(address holder) private {
    if (tokenHolderIndices[holder] == 0) {
      tokenHolders.push(holder);
      tokenHolderIndices[holder] = tokenHolders.length;
    }
    isTokenHolder[holder] = true;
  }

  function _removeTokenHolder(address holder) private {
    uint256 index = tokenHolderIndices[holder];
    if (index == 0) {
      return;
    }

    uint256 lastIndex = tokenHolders.length;
    if (index != lastIndex) {
      address lastHolder = tokenHolders[lastIndex - 1];
      tokenHolders[index - 1] = lastHolder;
      tokenHolderIndices[lastHolder] = index;
    }
    tokenHolders.pop();
    tokenHolderIndices[holder] = 0;
  }

  // IERC20

  function allowance(address owner, address spender) external view override returns (uint256) {
    return allowances[owner][spender];
  }

  function transfer(address to, uint256 value) external override returns (bool) {
    uint256 balance = balanceOf[msg.sender];
    require(balance >= value, "Insufficient balance");
    require(to != address(0), "Invalid recipient address");

    balanceOf[msg.sender] = balance.sub(value);
    balanceOf[to] = balanceOf[to].add(value);

    if (balanceOf[msg.sender] == 0) {
      _removeTokenHolder(msg.sender);
    }
    if (balanceOf[to] > 0) {
      _addTokenHolder(to);
    }

    return true;
  }

  function approve(address spender, uint256 value) external override returns (bool) {
    require(spender != address(0), "Invalid spender address");
    allowances[msg.sender][spender] = value;
    return true;
  }

  function transferFrom(address from, address to, uint256 value) external override returns (bool) {
    uint256 balance = balanceOf[from];
    require(balance >= value, "Insufficient balance");
    require(to != address(0), "Invalid recipient address");
    require(allowances[from][msg.sender] >= value, "Insufficient allowance");

    balanceOf[from] = balance.sub(value);
    balanceOf[to] = balanceOf[to].add(value);
    allowances[from][msg.sender] = allowances[from][msg.sender].sub(value);

    if (balanceOf[from] == 0) {
      _removeTokenHolder(from);
    }
    if (balanceOf[to] > 0) {
      _addTokenHolder(to);
    }

    return true;
  }

  // IMintableToken

  function mint() external payable override {
    require(msg.value > 0, "No funds supplied!");

    balanceOf[msg.sender] = balanceOf[msg.sender].add(msg.value);
    totalSupply = totalSupply.add(msg.value);
    _addTokenHolder(msg.sender);
  }

  function burn(address payable dest) external override {
    uint256 balance = balanceOf[msg.sender];
    require(balance > 0, "No tokens to burn!");

    balanceOf[msg.sender] = 0;
    totalSupply = totalSupply.sub(balance);
    _removeTokenHolder(msg.sender);

    (bool success, ) = dest.call{value: balance}("");
    require(success, "Transfer failed.");
  }

  // IDividends

  function getNumTokenHolders() external view override returns (uint256) {
    return tokenHolders.length;
  }

  function getTokenHolder(uint256 index) external view override returns (address) {
    if (index == 0 || index > tokenHolders.length) {
      return address(0);
    }
    return tokenHolders[index - 1];
  }

  function recordDividend() external payable override {
    require(msg.value > 0, "No funds supplied!");

    for (uint256 i = 0; i < tokenHolders.length; i++) {
      address holder = tokenHolders[i];
      uint256 dividendShare = msg.value.mul(balanceOf[holder]).div(totalSupply);
      dividends[holder] = dividends[holder].add(dividendShare);
    }
  }

  function getWithdrawableDividend(address payee) external view override returns (uint256) {
    require(payee != address(0), "Invalid payee address");
    return dividends[payee].sub(withdrawnDividends[payee]);
  }

  function withdrawDividend(address payable dest) external override {
    require(dest != address(0), "Invalid destination address");
    uint256 withdrawableDividend = dividends[msg.sender].sub(withdrawnDividends[msg.sender]);
    require(withdrawableDividend > 0, "No dividends available for withdrawal");
    withdrawnDividends[msg.sender] = dividends[msg.sender];

    (bool success, ) = dest.call{value: withdrawableDividend}("");
    require(success, "Transfer failed.");
  }
}