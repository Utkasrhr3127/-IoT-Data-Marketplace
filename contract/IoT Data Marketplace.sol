// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IoTDataMarketplace {
    struct DataListing {
        uint256 id;
        address payable seller;
        string dataHash; // IPFS or similar hash reference
        uint256 price;
        bool isSold;
    }

    uint256 public listingCounter = 0;
    mapping(uint256 => DataListing) public listings;

    event DataListed(uint256 id, address seller, uint256 price);
    event DataPurchased(uint256 id, address buyer);

    // Function to list IoT data for sale
    function listData(string memory _dataHash, uint256 _price) public {
        listingCounter++;
        listings[listingCounter] = DataListing(
            listingCounter,
            payable(msg.sender),
            _dataHash,
            _price,
            false
        );

        emit DataListed(listingCounter, msg.sender, _price);
    }

    // Function to purchase IoT data
    function purchaseData(uint256 _id) public payable {
        DataListing storage listing = listings[_id];
        require(!listing.isSold, "Data already sold");
        require(msg.value >= listing.price, "Insufficient payment");

        listing.seller.transfer(listing.price);
        listing.isSold = true;

        emit DataPurchased(_id, msg.sender);
    }

    // Function to fetch data details (doesn't reveal actual data)
    function getDataDetails(uint256 _id) public view returns (
        uint256,
        address,
        string memory,
        uint256,
        bool
    ) {
        DataListing memory listing = listings[_id];
        return (
            listing.id,
            listing.seller,
            listing.dataHash,
            listing.price,
            listing.isSold
        );
    }
}
