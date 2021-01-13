import java.util.*;

public class Graph {
    private int[][] table;
    private Node[] nodes;

    public Graph(int[][] table) {
        int numNodes = table.length;
        this.nodes = new Node[numNodes];
        this.table = table;

        for(int i = 0; i < numNodes; i++) {
            this.nodes[i] = new Node((char) ((int) 'A' + i));
        }
    }

    public Node getNode(char name) {
        for(Node node : nodes) {
            if(node.name == name) {
                return node;
            }
        }
        return null;
    }

    public Node getLastNode() {
        return nodes[nodes.length - 1];
    }

    public int getDistance(Node a, Node b) {
        int indexA = (int) a.getName() - (int) 'A';
        int indexB = (int) b.getName() - (int) 'A';

        return table[indexA][indexB];
    }

    public List<Node> getConnectedNodes(Node node) {
        Map<Integer, Node> map = new HashMap<Integer,Node>();

        for(int i = 0; i < nodes.length; i++) {
            int distance = table[i][(int) node.getName() - (int) 'A'];
            if(distance != 0) {
                map.put(this.getDistance(node, nodes[i]), nodes[i]);
            }
        }
        Map<Integer, Node> sortedMap = new TreeMap<Integer, Node>(map);
        List<Node> connectedNodes = new ArrayList<Node>();

        for(int key : sortedMap.keySet()) {
            connectedNodes.add(sortedMap.get(key));
        }

        return connectedNodes;
    }

    public Node getNearestNode(Node source) {
        Node nearestNode = null;
        int minDistance = Integer.MAX_VALUE;
        for(Node node : this.getConnectedNodes(source)) {
            if(node.getDistance() == Integer.MAX_VALUE) {
                continue;
            }
            int distance =  node.getDistance() + this.getDistance(source, node);
            if(distance < minDistance) {
                minDistance = distance;
                nearestNode = node;
            }
        }
        println("Nearest Node for '" + source.getName() + "' is '" + nearestNode.getName() + "'");
        return nearestNode;
    }

    @Override
    public String toString() {
        String str = "Nodes:\n";
        for(Node node : this.nodes) {
            str = str + node.getName() + " ";
        }
        return str;
    }
}