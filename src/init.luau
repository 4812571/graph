type Node = any
type Edge = any

local Graph = {}
Graph.__index = Graph

function Graph.new()
    local self = setmetatable({}, Graph)
    self._edges = {}
    return self
end

function Graph:_addEdge(node1: Node, node2: Node, edge: Edge?)
    -- If the node is not in the graph, add it
    if not self._edges[node1] then
        self._edges[node1] = {}
    end

    -- If the edge is not specified, 'true' is used as a default
    self._edges[node1][node2] = if edge ~= nil then edge else true
end

--[=[
    @within Graph
    Creates an edge between two nodes in the graph. Data can be stored in the edge.
]=]
function Graph:AddEdgePair(node1: Node, node2: Node, edge: Edge?)
    self:_addEdge(node1, node2, edge)
    self:_addEdge(node2, node1, edge)
end

function Graph:_removeEdge(node1: Node, node2: Node)
    -- If the node is not in the graph, it has no edges, so return early
    if not self._edges[node1] then
        return
    end

    -- Remove the edge from the graph
    self._edges[node1][node2] = nil

    -- If the node has no remaining edges, remove it from the graph
    if not next(self._edges[node1]) then
        self._edges[node1] = nil
    end
end

function Graph:RemoveEdgePair(node1: Node, node2: Node)
    self:_removeEdge(node1, node2)
    self:_removeEdge(node2, node1)
end

function Graph:RemoveNode(node: Node)
    -- Remove all edges to the node
    for otherNode, _ in self._edges[node] do
        self:_removeEdge(otherNode, node)
    end
    
    -- Remove the node from the graph
    self._edges[node] = nil
end

function Graph:GetNodes(): {[Node]: {Edge}}
    return self._edges
end

function Graph:GetEdges(node: Node): {Edge}
    if not self._edges[node] then
        return {}
    end

    return self._edges[node]
end

function Graph:GetEdge(node1: Node, node2: Node): Edge
    if not self._edges[node1] then
        return nil
    end

    return self._edges[node1][node2]
end

function Graph:HasEdge(node1: Node, node2: Node): boolean
    if not self._edges[node1] then
        return false
    end

    return self._edges[node1][node2] ~= nil
end

return Graph