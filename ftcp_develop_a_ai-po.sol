pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract FTCpDataVisualizationDashboard {
    using SafeMath for uint256;

    struct DataSet {
        string name;
        uint256[] data;
    }

    struct Visualization {
        string type; // (e.g. line, bar, scatter)
        string title;
        DataSet[] datasets;
    }

    address private owner;
    mapping(string => Visualization) private visualizations;
    string[] private visualizationNames;

    event NewVisualization(string name, string type);
    event UpdateVisualization(string name, string type);

    constructor() public {
        owner = msg.sender;
    }

    function createVisualization(string memory _name, string memory _type) public {
        require(msg.sender == owner, "Only the owner can create visualizations");
        Visualization storage visualization = visualizations[_name];
        visualization.type = _type;
        visualization.title = _name;
        visualizationNames.push(_name);
        emit NewVisualization(_name, _type);
    }

    function updateVisualization(string memory _name, string memory _type) public {
        require(msg.sender == owner, "Only the owner can update visualizations");
        Visualization storage visualization = visualizations[_name];
        visualization.type = _type;
        emit UpdateVisualization(_name, _type);
    }

    function addDataSet(string memory _visualizationName, string memory _datasetName, uint256[] memory _data) public {
        require(msg.sender == owner, "Only the owner can add datasets");
        Visualization storage visualization = visualizations[_visualizationName];
        DataSet memory dataset = DataSet(_datasetName, _data);
        visualization.datasets.push(dataset);
    }

    function getVisualization(string memory _name) public view returns (Visualization memory) {
        return visualizations[_name];
    }

    function getVisualizationNames() public view returns (string[] memory) {
        return visualizationNames;
    }
}