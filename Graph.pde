import java.util.*;

public class Graph {
    private int[][] table;
    private Node[] nodes;

    public Graph(String sourcePath) {
        Table csv = loadTable(sourcePath, "header");
        int numNodes = csv.getRowCount();
        
        this.table = new int[numNodes][numNodes];
        this.nodes = new Node[numNodes];

        for(int i = 0; i < numNodes; i++) {
            char name = (char) ((int) 'a' + i);
            this.nodes[i] = new Node(name);

            for(int j = 0; j < numNodes; j++) {
                table[i][j] = csv.getInt(j, Character.toString(name));
                print(table[i][j] + " ");
            }
            print("\n");
        }
    }

    public Node getNode(char name) {
        return this.nodes[(int) name - (int) 'a'];
    }

    public Node getFirstNode() {
        return this.nodes[0];
    }

    public Node getLastNode() {
        return this.nodes[nodes.length - 1];
    }

    public Node[] getNodes() {
        return this.nodes;
    }

    public int[][] getTable() {
        return this.table;
    }

    public int getDistanceBetween(Node a, Node b) {
        int indexA = (int) a.getName() - (int) 'a';
        int indexB = (int) b.getName() - (int) 'a';

        return this.table[indexA][indexB];
    }

    public List<Node> getConnectedNodes(Node node) {
        List<Node> connectedNodes = new ArrayList<Node>();

        for(int i = 0; i < nodes.length; i++) {
            int distance = this.getDistanceBetween(node, nodes[i]);
            if(distance != 0) {
                nodes[i].setSourceDistance(distance);
                connectedNodes.add(nodes[i]);
            }
        }

        Collections.sort(connectedNodes);
        return connectedNodes;
    }

    public Node getNearestNode(Node source) {
        Node nearestNode = null;
        int minDistance = Integer.MAX_VALUE;

        for(Node node : this.getConnectedNodes(source)) {
            int distance = node.getDistance() + this.getDistanceBetween(source, node);
            if(distance < minDistance && node.getDistance() != Integer.MAX_VALUE) {
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
            str += (node.getName() + " ");
        }
        return str;
    }
}