public class Node implements Comparable<Node> {
    private char name;
    private int distance;
    private boolean finished;
    private Node source;

    private Integer sourceDistance;
    private PVector drawPosition;

    Node(char name) {
        this.name = name;
        this.finished = false;
        this.distance = Integer.MAX_VALUE;
        this.source = null;
        this.drawPosition = new PVector();
        this.sourceDistance = new Integer(0);
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

    public void setSourceDistance(Integer sourceDistance) {
        this.sourceDistance = sourceDistance;
    }

    public Integer getSourceDistance() {
        return this.sourceDistance;
    }

    public void setDrawPosition(PVector drawPosition) {
        this.drawPosition = drawPosition;
    }

    public PVector getDrawPosition() {
        return this.drawPosition;
    }

    @Override
    public int compareTo(Node node) {
        return this.getSourceDistance().compareTo(node.getSourceDistance());
    }
}