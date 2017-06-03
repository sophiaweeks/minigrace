import "identifierKinds" as k

def completed = Singleton.named "completed"
def inProgress = Singleton.named "inProgress"
def undiscovered = Singleton.named "undiscovered"
// constants used in detecting cyclic inheritance

type Scope = interface {
    hash -> Number
        // returns my hash

    serialNumber -> Number
        // a uid for this scope

    == (other:Object) -> Boolean
        // object identity: returns true iff other is this scope

    isEmpty -> Boolean
        // returns true is there are no symbols defined in this scope

    addName (n:String) as (kind:DeclKind) -> Done
        // adds n as a kind; creates a synthetic parse node to represent the declaration

    addNode (nd:astNode) as (kind:DeclKind) -> Done
        // adds nd.nameString to this scope.  kind specifies whether the
        // declaration of nd is local or from a parent (use or inherit clause)

    contains (n:String) -> Boolean
        // returns true if n has been added to this scope

    withSurroundingScopesDo (action:Procedure1⟦Scope⟧) -> Done {
        // do action in this scope, and then in all surrounding scopes.

    keysAsList -> List⟦String⟧
        // the names in this scope

    keysAndKindsDo (action:Procedure2⟦String, DeclKind⟧) -> Done
        // applies action to each of the names and corresponding kinds in this scope.

    kind (name:String) -> DeclKind
        // the kind of name, if it is in this scope.  Otherwise, raises an exception

    kind (n) ifAbsent (action:Function0⟦W⟧) -> DeclKind | W
        // the kind of name, if it is in this scope.  Otherwise, applies action and
        // returns its result

    at (name:String) putScope (s:Scope)
        // adds name to this Scope's names with s as its scope

    getScope(name) -> Scope
        // returns the scope of name, as set by at(_)putScope(_)

    asStringWithParents -> String
        // a representation of this scope and its parents as a string

    asString -> String
        // a representation of this scope as a string

    asDebugString -> String
        // a representation of this scope that includes its serialNumber

    elementScopesAsString
        // a string represntation of the scopes of those of my elements that have
        // scopes (i.e., that return a scope from getScope)

    parent -> Scope
        // the scope that surrounds this scope; nullScope if I am at the top level

    hasParent -> Boolean
        // returns true if this scope is not at the top-level

    variety -> String
        // returns a string desciribing the nature of this scope.  One of
        // object, module, dialect, class, built-in, method or block.
        // TODO: turn these into singleton objects.

    node -> AstNode
        // the node that declared this scope.  For example, if I'm a method scope,
        // node returns the parse-tree node that declares the method

    inheritedNames -> Singleton
        // returns one of the Singletons undiscovered, inProgress and completed.
        // this refers to the process of adding parent names (intorduced by use
        // and inherit statements) into this scope. When this value is completed,
        // all such names are included in this scope.

    hasDefinitionInNest(name:String) -> Boolean
        // returns true if name is defined in this scope, or in any of the
        // surrounding scopes.

    kindInNest(name:String) -> DeclKind
        // returns the kind associated with name if it is defined in this scope,
        // or in any of the surrounding scopes.  Returns k.undefined otherwise

    scopeInNest(name:String) -> Scope
        // returns the scope associated with name if it is defined in this scope,
        // or in any of the surrounding scopes.  Returns universalScope otherwise.

    thatDefines(name) ifNone(action:Function0⟦W⟧) -> Scope | W
        // returns the scope taht defines name if it is defined in this scope,
        // or in any of the surrounding scopes. Applies action otherwise.

    receiverScope(rcvrNode:AstNode) -> Scope
        // rcvrNode is the receiver of a request. Answer the scope
        // associated with it.  So, if the receiver is a.b.c,
        // find the scope associated with c in the scope associated with b
        // in the scope associated with a in this scope.  Answers
        // universalScope if we don't have enough information to be exact.

    isInSameObjectAs (otherScope) -> Boolean
        // returns true if this scope (which is not an object scope) is nested
        // in the same object as otherScope.

    isMethodScope -> Boolean
        // returns true if this scope is defined by a method

    isModuleScope -> Boolean
        // returns true if this scope is defined by a module

    isInheritableScope -> Boolean
        // returns true if this scope is defined by a class or object constructor,
        // and is thus inheritable

    resolveOuterMethod (name:String) fromNode (aNode:AstNode) -> AstNode
        // returns an AstNode that represents thecorrect expansion of name in
        // the current scope, for exmaple, prelude.{name}, or self.{name}.
        // aNode is used only to provide context for error messages.
        // TODO: move this out of the scope object/

    scopeReferencedBy(nd:ast.AstNode) -> Self
        // Finds the scope referenced by astNode nd.
        // If nd references an object, then the returned
        // scope will have bindings for the methods of that object.
        // Otherwise, it will be the empty scope.




