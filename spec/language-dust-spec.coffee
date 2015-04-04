describe 'Dust grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-dust')

    runs ->
      grammar = atom.grammars.grammarForScopeName('text.html.dust')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'text.html.dust'

  it 'parses references', ->
    {tokens} = grammar.tokenizeLine("{name}")

    expect(tokens[0]).toEqual value: '{', scopes: ['text.html.dust', 'variable.other.reference.dust']
    expect(tokens[1]).toEqual value: 'name', scopes: ['text.html.dust', 'variable.other.reference.dust', 'variable.other.identifier.dust']
    expect(tokens[2]).toEqual value: '}', scopes: ['text.html.dust', 'variable.other.reference.dust']
