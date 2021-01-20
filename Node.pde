public class Node {
    private char name;
    private int distance;
    private boolean finished;
    private Node source;

    private PVector drawPosition;

    Node(char name) {
        this.name = name;
        this.finished = false;
        this.distance = Integer.MAX_VALUE;
        this.source = null;
        this.drawPosition = new PVector();
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
        return this.finished;
    }

    public void setSource(Node source) {
        this.source = source;
    }

    public Node getSource() {
        return this.source;
    }

    public void setDrawPosition(PVector drawPosition) {
        this.drawPosition = drawPosition;
    }

    public PVector getDrawPosition() {
        return this.drawPosition;
    }
}