import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.util.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Dijkstra extends PApplet {



public void setup() {
    
    Graph g = new Graph("graph1.csv");

    

    List<Node> path = getPath(g);

    
    printNodeList(path, "Shortest path");


}

public List<Node> getPath(Graph g) {
    List<Node> path = new ArrayList<Node>();
    Node start = g.getFirstNode();
    
    start.setDistance(0);
    start.finish();
    getPathLength(start, g);
    println("The shortest distance between 'a' and '" + g.getLastNode().getName() + "' is " + g.getLastNode().getDistance());

    Node currentNode = g.getLastNode();
    while (currentNode != null) {
        path.add(currentNode);
        currentNode = currentNode.getSource();
    }

    return path;
}

public void getPathLength(Node current, Graph g) {
    List<Node> connectedNodes = g.getConnectedNodes(current);

    println("==> Entering Node '" + current.getName() + "'");

    for(Node node : connectedNodes) {
        if(node == current.getSource() || node.isFinished()) {
            continue;
        }

        println("Checking Node '" + node.getName() + "'");

        int distance = current.getDistance() + g.getDistance(current, node);
        if(node.getDistance() > distance) { 
            node.setDistance(distance);
            node.setSource(current);
            println("Added Node '" + node.getName() + "' connected from Node '" + current.getName() + "' with distance " + node.getDistance());
        }
    }

    for(Node node : connectedNodes) {
        if(g.getNearestNode(node).isFinished() && !(node == current.getSource() || node.isFinished())) {
            node.finish();
            println("Finished '" + node.getName() + "'");
            getPathLength(node, g);
        }
    }
}

public void printNodeList(List<Node> nodes, String label) {
    println(label + ":");
    for(Node node : nodes) {
        print(node.getName() + " ");
    }
    print("\n");
}


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
        return nodes[(int) name - (int) 'a'];
    }

    public Node getFirstNode() {
        return nodes[0];
    }

    public Node getLastNode() {
        return nodes[nodes.length - 1];
    }

    public int getDistance(Node a, Node b) {
        int indexA = (int) a.getName() - (int) 'a';
        int indexB = (int) b.getName() - (int) 'a';

        return table[indexA][indexB];
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


public void drawGraph(Graph g, List<Node> path) {

}
public class Node {
    private char name;
    private int distance;
    private boolean finished;
    private Node source;

    Node(char name) {
        this.name = name;
        this.finished = false;
        this.distance = Integer.MAX_VALUE;
        this.source = null;
    }

    public char getName() {
        return this.name;
    }

    public int getDistance() {
        return this.distance;
    }

    public void setDistance(int distance) {
        this.distance = distance;
    }

    public void finish() {
        this.finished = true;
    }

    public boolean isFinished() {
        return finished;
    }

    public void setSource(Node node) {
        this.source = node;
    }

    public Node getSource() {
        return this.source;
    }
}
  public void settings() {  size(400, 400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Dijkstra" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
