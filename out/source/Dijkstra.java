import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

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



/*int[][] table = {
    { 0,  6,  0,  2,  0,  0},
    { 6,  0,  4,  5,  4,  9},
    { 0,  4,  0,  6,  4,  7},
    { 2,  5,  6,  0,  9,  0},
    { 0,  4,  4,  9,  0,  2},
    { 0,  9,  7,  0,  2,  0}
};*/
int[][] table = {
    { 0,  4,  0,  2,  0,  0},
    { 4,  1,  5,  0,  0,  0},
    { 0,  5,  0,  6,  4,  2},
    { 2,  0,  6,  0,  5,  0},
    { 0,  0,  4,  5,  0,  5},
    { 0,  0,  2,  0,  5,  0}
};


public void setup() {
    
    Graph g = new Graph(table);

    Node start = g.getNode('A');
    start.setDistance(0);
    start.finish();
    getPathLength(start, g);
    println("The shortest distance between 'A' and '" + g.getLastNode().getName() + "' is " + g.getLastNode().getDistance());

    printNodeList(getPath(g), "Shortest path");
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
        if(node == current.getSource() || node.isFinished()) {
            continue;
        }

        if(g.getNearestNode(node).isFinished()) {
            node.finish();
            println("Finished '" + node.getName() + "'");
            getPathLength(node, g);
        }
    }
}

public List<Node> getPath(Graph g) {
    List<Node> path = new ArrayList<Node>();

    Node currentNode = g.getLastNode();
    while (currentNode != null) {
        path.add(currentNode);
        currentNode = currentNode.getSource();
    }

    return path;
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
