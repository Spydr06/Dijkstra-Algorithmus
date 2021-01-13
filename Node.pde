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