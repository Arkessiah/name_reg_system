pragma solidity >=0.8.10;

/** STRUCTS */
contract NRSrun is Destructible {
    struct DomainDetails {
        bytes name;
        address owner;
        bytes15 ip;
        uint expires;
    }

    
    /** CONSTANTS */
uint constant public DOMAIN_NAME_COST = 1 ether;
uint constant public DOMAIN_NAME_COST_SHORT_ADDITION = 1 ether;
uint constant public DOMAIN_EXPIRATION_DATE = 365 days;
uint8 constant public DOMAIN_NAME_EXPENSIVE_LENGTH = 8;

/** VARIABLES */
mapping (bytes32 => DomainDetails) public domainNames;
mapping (address => bytes32[]) public paymentReceipts;
mapping (bytes32 => Receipt) public receiptDetails;

modifier isAvalible(bytes32 memory domain) {
    bytes32 domainHash = getDomainHash(domain);
    require(
        domainNames[domainHash].expires < block.timestamp, "Domain is not avalible"
    );
}

modifier isDomainOwner(bytes memory domain){
    bytes32 domainHash = getDomainHash(domain);
    require(
        domainNames[domainHash].owner == msg.sender, "You are not the owner"
    );
}

modifier collectDomainNamePayment(bytes memory domain){
    uint domainPrice = getPrice(domain);
    require(
        msg.value >= domainPrice,
        "Insufficient amount"
    );
}


event LogDomainNameRegistered(
    uint indexed timestamp,
    bytes domainName
);

event LogDomainNameRenewed(
    uint indexed timestamp,
    bytes domainName,
    address indexed owner
);

event LogPurchaseChangeReturned(
    uint indexed timestamp,
    address indexed _owner,
    uint amount
);

event LogDomainNameTransferred(
    uint indexed timestamp,
    bytes domainName,
    address indexed owner,
    address newOwner
); 

event LogDomainNameEdited(
    uint indexed timestamp,
    bytes domainName,
    bytes15 newIP
);

event LogReceipt(
    uintindexed timestamp,
    bytes domainName,
    uint amountInWei,
    uint expires
);

/** CONSTRUCTOR */
constructor() public{

}

function register(
    bytes memory domain,
    bytes15 ip
)

isDomainNameLenghtAllowed(domain)
isAvailable(domain)
collectDomainNamePayment(domain)
{
    bytes32 domainHash = getDomainHash(domain);

    DomainDetails memory newDomain = DomainDetails(
        {
            name: domain,
            ownermsg.sender,
            ip: ip,
            expires: block.timestamp + DOMAIN_EXPIRATION_DATE
        }
    );

    domainNamess[domainHash] = newDomain;

    Receipt memory newReceipt = Receipt (
        {
            amountPaidWei: DOMAIN_NAME_COST,
            timestamp: block.timestamp,
            expires: block.timestamp + DOMAIN_EXPIRATION_DATE
        }
    );
    bytes32 receiptKey = getReceipt(domain);

    paymentReceipts[msg.sender].push(receiptKey);

    receiptDetails[receiptKey] = newReceipt;

    emit LogReceipt(
        block.timestamp,
        domain,
        DOMAIN_NAME_COST,
        block.timestamp + DOMAIN_EXPIRATION_DATE
    );

    emit LogDomainNameRegistered(
        block.timestamp,
        domain
    );
}

function renewDomainName(
    bytes memory domain
)

isDomainOwner(domain)
collectDomainNamePayment(domain)

{
    bytes32 domainHash = getDomainHash(domain);
    domainNames[domainHash].expires += 365 days;

    Receipt memory newReceipt = Receipt(
        {
            amountPaidWei: DOMAIN_NAME_COST,
            timestamp: block.timestamp,
            expires: block.timestamp + DOMAIN_EXPIRACION_DATE
        }
    );

    emit LogDomainNameRenewed(
        block.timestamp,
        domain,
        msg.sender
    );

    emit LogReceipt(
        block.timestamp,
        domain,
        DOMAIN_NAME_COST,
        block.timestamp + DOMAIN_EXPIRATION_DATE
    );
}

function transferDomain(
    bytes memory domain,
    address newOwner
)

isDomainOwner(domain)

{
    require(newOwner != address(0));

    bytes32 domainHash = getDomainHash(domain);

    domainNames[domainHash].owner = newOwner;

    emit LogDomainNameTransferred(
        block.timestamp,
        domain,
        msg.sender,
        newOwner
    );
}

function getPrice(
    bytes memory domain
)
returns(uint)

{
    if (domain.lenght < DOMAIN_NAME_EXPENSIVE_LENGTH){
        return DOMAIN_NAME_COST + DOMAIN_NAME_COST_SHORT_ADDITION;
    }

    return DOMAIN_NAME_COST;
    
    function getReceiptList() public view returns (bytes32[] memory) {
        return paymentReceipts[msg.sender];
    }

    function getReceipt(bytes32 receiptKey) public view returns (uint, uint, uint) {
        return (receiptDetails[receiptKey].amountPaidWei,
                receiptDetails[receiptKey].timestamp,
                receiptDetails[receiptKey].expires);
    }

    function withdraw() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }
}

}

