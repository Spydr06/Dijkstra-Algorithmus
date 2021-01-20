import java.util.*;

public class Graph {
    private int[][] table;
    private Node[] nodes;

    public Graph(int[][] table) {
        int numNodes = table.length;
        this.nodes = new Node[numNodes];
        this.table = table;

        for(int i = 0; i < numNodes; i++) {
            this.nodes[i] = new Node((char) ((int) 'a' + i));
        }
    }

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

    public int getDistance(Node a, Node b) {
        int indexA = (int) a.getName() - (int) 'a';
        int indexB = (int) b.getName() - (int) 'a';

        return this.table[indexA][indexB];
    }

    public List<Node> getConnectedNodes(Node node) {
        Map<Integer, Node> map = new TreeMap<Integer,Node>(); //Eine map mit allen verbunden Knoten als Werte und deren Distanzen als Schlüssel (TreeMap, weil die Einträge (im Gegensatz zu HashMaps) automatisch nach den Schlüsseln sortiert werden)

        for(int i = 0; i < nodes.length; i++) {
            int distance = table[i][(int) node.getName() - (int) 'a'];
            if(distance != 0) {
                map.put(this.getDistance(node, nodes[i]), nodes[i]);
            }
        }

        List<Node> connectedNodes = new ArrayList<Node>();
        for(int key : map.keySet()) {
            connectedNodes.add(map.get(key));
        }
        return connectedNodes;
    }

    public Node getNearestNode(Node source) {
        Node nearestNode = null;
        int minDistance = Integer.MAX_VALUE;

        for(Node node : this.getConnectedNodes(source)) {
            int distance = node.getDistance() + this.getDistance(source, node);
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