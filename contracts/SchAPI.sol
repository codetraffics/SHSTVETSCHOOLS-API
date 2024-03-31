// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

contract schAPI {
    struct School {
        uint256 id;
        string region;
        string district;
        string name;
        string location;
        string gender;
        string residency;
        string email;
    }

    address owner;

    School public deleted;

    mapping(uint256 => School) public schools;
    School[] public schArray;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "ACCESS DENIED! YOU ARE NOT THE OWNER");
        _;
    }

    // Events 
    event CreateNewSch(uint256 id, string name, string location);
    event UpdateExistingSch(uint256 id, string name);
    event DeleteExistingSch(uint256 id);
    

    function addSch (uint256 _id, string memory _region, string memory _district, string memory _name, string memory _location, string memory _gender, string memory _residency, string memory _email) public onlyOwner {
        School memory school = School(_id, _region, _district, _name, _location, _gender, _residency, _email);
        schools[_id] = school;
        schArray.push(School(_id, _region, _district, _name, _location, _gender, _residency, _email));
   
        emit CreateNewSch(_id, _name, _location);
    }

    function getSch (uint256 _id) public view returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
        require(schools[_id].id != 0, "SCHOOL IS NOT AVAILABLE");
        School memory school = schools[_id];
        return (school.region, school.district, school.name, school.location, school.gender, school.residency, school.email);
    }

    function getAllSchs() public view returns (School[] memory) {
        return schArray;
    }

    function updateSch (uint256 _id, string memory _region, string memory _district, string memory _name, string memory _location, string memory _gender, string memory _residency, string memory _email) public onlyOwner {
        require(schools[_id].id != 0, "SCHOOL IS NOT AVAILABLE");
        deleteSch(_id);
        schools[_id] = School(_id, _region, _district, _name, _location, _gender, _residency, _email);
        schArray.push(School(_id, _region, _district, _name, _location, _gender, _residency, _email)); 
    
        emit UpdateExistingSch(_id, _name);
    }

    function deleteSch (uint256 _id) public onlyOwner {
        require(schools[_id].id != 0, "SCHOOL IS NOT AVAILABLE");
        delete schools[_id];
        for (uint i = 0; i < schArray.length; i++) {
            if (schArray[i].id == _id) {
                deleted = schArray[i];
                schArray[i] = schArray[schArray.length - 1];
                schArray[schArray.length - 1] = deleted;
            }
        }
        schArray.pop();

        emit DeleteExistingSch(_id);
    }

}