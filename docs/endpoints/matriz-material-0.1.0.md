# Matriz de endpoints de Materiais para a versão 0.1.0

## Fonte e critério de seleção

Esta matriz foi conferida em 28 de julho de 2026 no documento OpenAPI publicado
pela API do CNBS. O MVP seleciona somente operações `GET` necessárias para:

1. pesquisar materiais por termo textual;
2. consultar um material por código;
3. navegar pela hierarquia de grupo, classe e PDM; e
4. recuperar resultados tabulares úteis no R.

Operações de escrita ficam fora do escopo. Endpoints de leitura que ampliam os
mesmos dados, mas não são necessários para esses casos de uso mínimos, ficam
adiados para versões posteriores.

## Endpoints incluídos

| Endpoint | Função pública | Caso de uso |
| --- | --- | --- |
| `GET /material/v1/palavra` | `get_busca_material_por_palavra()` | Pesquisa textual |
| `GET /material/v1/codigoPdmClasse` | `get_codigo_pdm_classe()` | Hierarquia por classe ou PDM |
| `GET /material/v1/dadosbasicospdmporcodigo` | `get_dados_basicos_pdm_por_codigo()` | Dados básicos e hierarquia do PDM |
| `GET /material/v1/dadosItemMaterialporCodigo` | `get_dados_item_material_por_codigo()` | Descrição do item por código |
| `GET /material/v1/dadosItemMaterialporCodigoSiasgnet` | `get_dados_item_material_por_codigo_siasgnet()` | Indicadores do item por código |
| `GET /material/v1/materialCaracteristicaValorPdmSemFiltro` | `get_material_caracteristica_valor_pdm_sem_filtro()` | Itens e características por PDM |

Os contratos individuais registram parâmetros, esquemas, paginação, respostas
vazias e erros observados. Nenhum dos seis endpoints expõe parâmetros de página
ou tamanho de página no OpenAPI atual.

## Endpoints de leitura adiados

| Endpoint | Motivo para adiamento |
| --- | --- |
| `GET /material/v1/grupo/{codigo}` | Consulta adicional de hierarquia |
| `GET /material/v1/classe/{codigo}` | Consulta adicional de hierarquia |
| `GET /material/v1/grupo` | Listagem adicional de grupos |
| `GET /material/v1/classe` | Listagem adicional de classes |
| `GET /material/v1/unidadeFornecimentoPorCodigoPdm` | Detalhe complementar de fornecimento |
| `GET /material/v1/unidadeFornecimentoPorCodigoItemMaterial` | Detalhe complementar de fornecimento |
| `GET /material/v1/situacaoitemmaterial` | Consulta complementar de situação |
| `GET /material/v1/recuperaDadosItemMaterialPorCodigo` | Sobreposição com consultas incluídas por código |
| `GET /material/v1/pdmPorCodigoPostgre` | Consulta alternativa de PDM |
| `GET /material/v1/materialCaracteristcaValorporPDM` | Sobreposição com consulta de características incluída |
| `GET /material/v1/itemPorCodigoMaterial` | Sobreposição com consultas incluídas por código |
| `GET /material/v1/grupo/codigosDisponiveis` | Listagem auxiliar fora dos casos mínimos |
| `GET /material/v1/existeunidadefornecimento` | Validação auxiliar fora dos casos mínimos |
| `GET /material/v1/dadosvalorcaracteristicapdmporcodigo` | Detalhe complementar de característica |
| `GET /material/v1/dadosunidademedidacaracteristicapdmporcodigo` | Detalhe complementar de característica |
| `GET /material/v1/dadosunidadefornecimentopdmporcodigo` | Detalhe complementar de fornecimento |
| `GET /material/v1/dadosnaturezadespesapdmporcodigo` | Classificação complementar |
| `GET /material/v1/dadositemmaterialcodigo` | Sobreposição com consultas incluídas por código |
| `GET /material/v1/dadoscaracteristicapdmporcodigo` | Detalhe complementar de característica |
| `GET /material/v1/dadoscaracteristicaparcialpdmporcodigo` | Detalhe complementar de característica |
| `GET /material/v1/dadosaliaspdmporcodigo` | Detalhe complementar de PDM |
| `GET /material/v1/classificacaoContabilPorCodigoPdm` | Classificação complementar |
| `GET /material/v1/classificacaoContabilPorCodigoItemMaterial` | Classificação complementar |
| `GET /material/v1/classe/codigosDisponiveis/` | Listagem auxiliar fora dos casos mínimos |
| `GET /material/v1/caracteristicaPorCodigoPdm` | Detalhe complementar de característica |
| `GET /material/v1/caracteristicaPorCodigoPdmSiglaAtiva` | Detalhe complementar de característica |

O adiamento não declara esses contratos estáveis nem garante sua incorporação
futura. Cada endpoint deverá passar pelo fluxo completo de documentação,
implementação, testes e versionamento antes de ser exportado.

## Operações excluídas

| Operação | Motivo para exclusão |
| --- | --- |
| `PUT /material/v1/grupo/{codigo}` | Escrita fora do escopo somente leitura |
| `PUT /material/v1/classe/{codigo}` | Escrita fora do escopo somente leitura |
| `POST /material/v1/ncmPorCodigoItemMaterial` | Operação não `GET` fora do MVP |
| `POST /material/v1/materialFaseInterna` | Operação não `GET` fora do MVP |
| `POST /material/v1/grupo` | Escrita fora do escopo somente leitura |
| `POST /material/v1/classe` | Escrita fora do escopo somente leitura |

## Confirmação dos casos de uso

Os endpoints incluídos atendem aos casos aprovados: `palavra` cobre pesquisa
textual; as duas consultas de item cobrem recuperação por código;
`codigoPdmClasse` e `dadosbasicospdmporcodigo` cobrem navegação hierárquica; e
`materialCaracteristicaValorPdmSemFiltro` liga PDMs aos itens e às suas
características. Todos os retornos públicos são `tibble`, com coluna-lista
apenas onde a estrutura aninhada não possui representação plana adequada.

## Referências

- [Swagger da API CNBS](https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/)
- [Decisão 0001 — Escopo do MVP 0.1.0](../decisions/0001-escopo-mvp.md)
- [Decisão 0002 — Interface pública 0.1.0](../decisions/0002-interface-publica-0.1.0.md)
