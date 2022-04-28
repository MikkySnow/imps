// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol



pragma solidity ^0.8.0;

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/utils/Context.sol



pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol



pragma solidity ^0.8.0;



/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

// File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol



pragma solidity ^0.8.0;

/**
 * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
 */
abstract contract ERC20Capped is ERC20 {
    uint256 private immutable _cap;

    /**
     * @dev Sets the value of the `cap`. This value is immutable, it can only be
     * set once during construction.
     */
    constructor(uint256 cap_) {
        require(cap_ > 0, "ERC20Capped: cap is 0");
        _cap = cap_;
    }

    /**
     * @dev Returns the cap on the token's total supply.
     */
    function cap() public view virtual returns (uint256) {
        return _cap;
    }

    /**
     * @dev See {ERC20-_mint}.
     */
    function _mint(address account, uint256 amount) internal virtual override {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }
}

// File: contracts/MultiOwnable.sol

pragma solidity ^0.8.3;

contract MultiOwnable {

  event AdminAdded(address newAdmin);
  event AdminRemoved(address admin);
  event ThresholdUpdated(uint256 newThreshold);
  event ActionProposed(uint256 id);

  mapping (address => bool) public isAdmin;
  mapping (uint256 => Proposal) public proposals;
  uint256 public adminsCount;
  uint256 public threshold;
  uint256 public proposalsCount;

  enum ActionType {
    ADD_ADMIN,
    REMOVE_ADMIN,
    CHANGE_THRESHOLD,
    OTHER
  }

  struct Proposal {
    ActionType actionType;
    bytes value;
    mapping (address => bool) isVoted;
    uint256 votesAmount;
    bool isExecuted;
  }
  

  constructor(address[] memory _admins) {
    for (uint i=0; i<_admins.length; i++) {
      isAdmin[_admins[i]] = true;
      threshold = _admins.length;
      adminsCount = _admins.length;
    }
  }

  modifier onlyAdmin() {
    require(isAdmin[msg.sender], "msg.sender is not admin");
    _;
  }

  modifier selfAuthorized() {
    require(msg.sender == address(this), "Only this contract can call this function");
    _;
  }

  function proposeAction(bytes memory _proposalData) public onlyAdmin {
    proposals[proposalsCount].isVoted[msg.sender] = true;
    proposals[proposalsCount].votesAmount = proposals[proposalsCount].votesAmount + 1;
    proposals[proposalsCount].value = _proposalData;
    proposals[proposalsCount].actionType = ActionType.OTHER;

    emit ActionProposed(proposalsCount);

    proposalsCount++;
  }

  function proposeAdminChange(ActionType _actionType, address _value) public onlyAdmin {
    // Validate action
    if (_actionType == ActionType.ADD_ADMIN) {
      require(!isAdmin[_value], "Address is already admin");
      require(_value != address(0), "Cannot add zero-address as owner");

    } else if (_actionType == ActionType.REMOVE_ADMIN) {
      require(isAdmin[_value], "Provided address is not admin");
      require(adminsCount > 1, "Cannot remove last admin");
      require(adminsCount - 1 >= threshold, "Threshold cannot be more than admins count");
    } else {
      revert("Wrong action ID");
    }

    proposals[proposalsCount].isVoted[msg.sender] = true;
    proposals[proposalsCount].votesAmount = proposals[proposalsCount].votesAmount + 1;
    proposals[proposalsCount].value = toBytes(bytes32(bytes20(_value)));
    proposals[proposalsCount].actionType = _actionType;

    emit ActionProposed(proposalsCount);

    proposalsCount++;
  }

  function proposeChangeThreshold(uint256 _newThreshold) public onlyAdmin {
    require(_newThreshold <= adminsCount, "Threshold cannot be more than admins count");

    proposals[proposalsCount].isVoted[msg.sender] = true;
    proposals[proposalsCount].votesAmount = proposals[proposalsCount].votesAmount + 1;
    proposals[proposalsCount].value = toBytes(bytes32(_newThreshold));
    proposals[proposalsCount].actionType = ActionType.CHANGE_THRESHOLD;

    emit ActionProposed(proposalsCount);

    proposalsCount++;
  }

  function confirmAction(uint256 _id) public onlyAdmin {
    require(proposals[_id].value.length != 0, "Proposal not found");
    require(!proposals[_id].isExecuted, "Proposal is already executed");
    require(!proposals[_id].isVoted[msg.sender], "You've already voted");

    proposals[_id].votesAmount = proposals[_id].votesAmount + 1;
    proposals[_id].isVoted[msg.sender] = true;

    if (proposals[_id].votesAmount >= threshold) {
      _executeAction(_id);
    }
  }

  function revokeConfirmation(uint256 _id) public onlyAdmin {
    require(!proposals[_id].isExecuted, "Proposal is already executed");
    require(proposals[_id].value.length != 0, "Proposal not found");
    require(proposals[_id].isVoted[msg.sender], "You didn't voted yet");

    proposals[_id].votesAmount = proposals[_id].votesAmount - 1;
    proposals[_id].isVoted[msg.sender] = false;
  }

  function addAdmin(address _newAdmin) public selfAuthorized {
    require(!isAdmin[_newAdmin], "Wrong new admin");

    isAdmin[_newAdmin] = true;
    adminsCount++;

    emit AdminAdded(_newAdmin);
  }

  function removeAdmin(address _admin) public selfAuthorized {
    require(isAdmin[_admin], "Admin not found");
    require(adminsCount > 1, "You're trying to remove last admin");
    require(adminsCount - 1 >= threshold, "Threshold cannot be more than admins count");

    isAdmin[_admin] = false;
    adminsCount--;

    emit AdminRemoved(_admin);
  }

  function changeThreshold(uint256 _newThreshold) public selfAuthorized {
    require(_newThreshold <= adminsCount, "Threshold cannot be more than admins count");
    
    threshold = _newThreshold;

    emit ThresholdUpdated(_newThreshold);
  }

  function executeConfirmedAction(uint256 _id) public {
    require(!proposals[_id].isExecuted, "Proposal is already executed");
    require(proposals[_id].value.length != 0, "Proposal not found");
    require(proposals[_id].votesAmount >= threshold, "There is not enough proposals");
    
    _executeAction(_id);
  }

  function _executeAction(uint256 _id) internal {
    if (proposals[_id].actionType == ActionType.ADD_ADMIN) {
      address newAdminAddress = bytesToAddress(proposals[_id].value);
      MultiOwnable(this).addAdmin(newAdminAddress);

    } else if (proposals[_id].actionType == ActionType.REMOVE_ADMIN) {
      address adminAddress = bytesToAddress(proposals[_id].value);
      MultiOwnable(this).removeAdmin(adminAddress);

    } else if (proposals[_id].actionType == ActionType.CHANGE_THRESHOLD) {
      MultiOwnable(this).changeThreshold(toUint256(proposals[_id].value));
    
    } else {
      (bool success, ) = address(this).call(proposals[_id].value);
      require(success, "Execution failed");
    } 

    proposals[_id].isExecuted = true;
  }

  function toBytes(bytes32 _data) internal pure returns (bytes memory) {
    return abi.encodePacked(_data);
  } 

  function toUint256(bytes memory _bytes) internal pure returns (uint256 _value) {
    assembly {
      _value := mload(add(_bytes, 0x20))
    }
  }

  function bytesToAddress(bytes memory _bytes) private pure returns (address addr) {
    assembly {
      addr := mload(add(_bytes,20))
    } 
  }
}

// File: contracts/IMP.sol

pragma solidity ^0.8.3;


contract IMP is ERC20Capped, MultiOwnable {

  constructor(
    string memory _name,
    string memory _symbol,
    address[] memory _owners,
    uint256 _cap
  ) ERC20(_name, _symbol) ERC20Capped(_cap) MultiOwnable(_owners) {}

  function mint(address _account, uint256 _amount) public selfAuthorized {
    _mint(_account, _amount);
  }

  function proposeMint(address _account, uint256 _amount) public onlyAdmin {
    bytes memory _proposalData = abi.encodeWithSignature("mint(address,uint256)", _account, _amount);
    proposeAction(_proposalData);
  }

  function burn(address _account, uint256 _amount) public selfAuthorized {
    _burn(_account, _amount);
  }

  function proposeBurn(address _account, uint256 _amount) public onlyAdmin {
    bytes memory _proposalData = abi.encodeWithSignature("burn(address,uint256)", _account, _amount);
    proposeAction(_proposalData);
  }
}
