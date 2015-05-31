(: function declarations :)
declare namespace functx = "http://www.functx.com";
declare function functx:is-node-among-descendants($node as node()?, $seq as node()* )  as xs:boolean {
	some $nodeInSeq in $seq/descendant-or-self::*/(.|@*)
	satisfies $nodeInSeq is $node
};

declare function functx:is-node-in-sequence($node as node()?, $seq as node()* )  as xs:boolean {
	some $nodeInSeq in $seq satisfies $nodeInSeq is $node
};

declare function functx:is-ancestor($node1 as node(), $node2 as node() )  as xs:boolean {
	exists($node1 intersect $node2/ancestor::node())
};

(: returns true if a node is an ancestor of at least one sequence element :)
declare function local:is-ancestor-seq($node as node(), $sequence as node()*) as xs:boolean {
	some $candidate in $sequence
	satisfies(functx:is-ancestor($node, $candidate))
};

declare function local:filter-elements-path($element as element(), $paths as element()*) as element() {
	element {node-name($element) }
	{$element/@*,
		for $child in $element/node()
			return if ($child instance of element())
				then if (functx:is-node-in-sequence($child, $paths))
					then local:copy($child)
				else (if (local:is-ancestor-seq($child, $paths))
					then local:filter-elements-path($child, $paths)
					else ())
			else $child
	}
};

(: copies a node with all its contents and descendents :)
declare function local:copy($element as element()) as element() {
	element { node-name($element)}
	{$element/@*,
		for $child in $element/node()
			return if ($child instance of element())
				then local:copy($child)
			else $child
	}
};

(: external variables declarations :)
declare variable $view external

(: ABAC attributes declarations :)

(: sanitizing view :)
(: building the set of elements that can be read :)
declare function local:resources() as element()* {
$view/(
/calview/event/starttime
)
};

(: filtering the view :)
{ 
	local:filter-elements-path($view/calview, local:resources())
}
