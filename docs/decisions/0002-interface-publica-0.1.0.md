# 0002 — Interface pública do MVP 0.1.0

## Status

Aceita em 28 de julho de 2026.

## Contexto

O levantamento dos endpoints de Materiais selecionou seis operações `GET` que
atendem aos casos de uso mínimos. A primeira interface estável precisa preservar
a rastreabilidade com a API sem expor detalhes do cliente HTTP.

## Decisão

A versão 0.1.0 exporta exatamente estas funções:

```r
get_busca_material_por_palavra(palavra, apenas_ativos = NULL)
get_codigo_pdm_classe(codigo_pdm_classe, busca_classe = NULL, busca_pdm = NULL)
get_dados_basicos_pdm_por_codigo(codigo_pdm)
get_dados_item_material_por_codigo(codigo_item_material)
get_dados_item_material_por_codigo_siasgnet(codigo_item_material)
get_material_caracteristica_valor_pdm_sem_filtro(codigo_pdm)
```

Os nomes acompanham os endpoints em `snake_case`. Códigos são inteiros positivos
escalares de 32 bits. Textos obrigatórios são escalares não vazios. Parâmetros
opcionais são omitidos quando `NULL` e encaminhados nos nomes esperados pela API.

Todos os resultados são `tibble`. Cada contrato define nomes, ordem e tipos de
colunas. A resposta pode trazer os campos em outra ordem, mas campos ausentes,
extras ou incompatíveis produzem erro informativo. Valores JSON `null` tornam-se
`NA` do tipo documentado. A coluna `buscaItemCaracteristica` permanece como
coluna-lista de tabelas com esquema igualmente estável; `tuplaCaracteristica`
permanece uma lista de vetores de texto.

Consultas válidas sem dados retornam zero linhas com o mesmo esquema. Respostas
HTTP malsucedidas, conteúdo que não seja JSON e estruturas incompatíveis geram
erros, sem retorno parcial silencioso.

Nenhum endpoint selecionado expõe paginação no OpenAPI atual. Por isso a versão
0.1.0 não possui argumentos de página ou tamanho. Caso um endpoint paginado seja
incorporado, a paginação será manual e não haverá agregação automática.

## Consequências

- As seis assinaturas passam a compor a interface estável da primeira versão.
- Mudanças inesperadas no contrato remoto são detectadas em vez de alterarem
  silenciosamente o resultado público.
- Novos campos e endpoints exigem documentação, testes e nova versão do pacote.
- Serviços, escrita, cache, banco local e paginação automática continuam fora do
  escopo.
