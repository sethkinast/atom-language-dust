describe 'Dust grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-dust-ng')

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

  describe 'Partial', ->
    it 'parses identifiers', ->
      {tokens} = grammar.tokenizeLine('Hello {>partial/}!')

      expect(tokens[0]).toEqual value: 'Hello ', scopes: ['text.html.dust']
      expect(tokens[1]).toEqual value: '{>', scopes: ['text.html.dust', 'keyword.control.partial.dust']
      expect(tokens[2]).toEqual value: 'partial', scopes: ['text.html.dust', 'keyword.control.partial.dust']
      expect(tokens[3]).toEqual value: '/}', scopes: ['text.html.dust', 'keyword.control.partial.dust']
      expect(tokens[4]).toEqual value: '!', scopes: ['text.html.dust']

    it 'parses inlines', ->
      {tokens} = grammar.tokenizeLine('Hello {>"{partial}"/}!')

      expect(tokens[0]).toEqual value: 'Hello ', scopes: ['text.html.dust']
      expect(tokens[1]).toEqual value: '{>', scopes: ['text.html.dust', 'keyword.control.partial.dust']
      expect(tokens[2]).toEqual value: '"', scopes: ['text.html.dust', 'keyword.control.partial.dust', 'string.quoted.double.inline', 'punctuation.definition.string.begin']
      expect(tokens[3]).toEqual value: '{', scopes: ['text.html.dust', 'keyword.control.partial.dust', 'string.quoted.double.inline', 'variable.other.reference.dust']
      expect(tokens[4]).toEqual value: 'partial', scopes: ['text.html.dust', 'keyword.control.partial.dust', 'string.quoted.double.inline', 'variable.other.reference.dust', 'variable.other.identifier.dust']
      expect(tokens[5]).toEqual value: '}', scopes: ['text.html.dust', 'keyword.control.partial.dust', 'string.quoted.double.inline', 'variable.other.reference.dust']
      expect(tokens[6]).toEqual value: '"', scopes: ['text.html.dust', 'keyword.control.partial.dust', 'string.quoted.double.inline', 'punctuation.definition.string.end']
      expect(tokens[7]).toEqual value: '/}', scopes: ['text.html.dust', 'keyword.control.partial.dust']
      expect(tokens[8]).toEqual value: '!', scopes: ['text.html.dust']
