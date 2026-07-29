# Matriz de endpoints de Materiais para a versão 0.1.1

## Fonte e critério de seleção

Esta matriz foi conferida em 29 de julho de 2026 no documento OpenAPI publicado
pela API do CNBS. A versão 0.1.1 preserva os seis endpoints da versão 0.1.0 e
incorpora `materialCaracteristcaValorporPDM`, mantendo o escopo restrito ao
catálogo de Materiais e a operações `GET`.

## Endpoints incluídos

| Endpoint | Função pública | Caso de uso |
| --- | --- | --- |
| `GET /material/v1/palavra` | `get_busca_material_por_palavra()` | Pesquisa textual |
| `GET /material/v1/codigoPdmClasse` | `get_codigo_pdm_classe()` | Hierarquia por classe ou PDM |
| `GET /material/v1/dadosbasicospdmporcodigo` | `get_dados_basicos_pdm_por_codigo()` | Dados básicos e hierarquia do PDM |
| `GET /material/v1/dadosItemMaterialporCodigo` | `get_dados_item_material_por_codigo()` | Descrição do item por código |
| `GET /material/v1/dadosItemMaterialporCodigoSiasgnet` | `get_dados_item_material_por_codigo_siasgnet()` | Indicadores do item por código |
| `GET /material/v1/materialCaracteristcaValorporPDM` | `get_material_caracteristica_valor_pdm(..., com_filtro = TRUE)` | Itens e características por PDM com filtro |
| `GET /material/v1/materialCaracteristicaValorPdmSemFiltro` | `get_material_caracteristica_valor_pdm_sem_filtro()` | Itens e características por PDM sem filtro |

Os contratos individuais registram parâmetros, esquemas, respostas vazias e
erros observados. Nenhum dos sete endpoints expõe parâmetros de paginação no
OpenAPI atual.

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
futura. Cada endpoint deve passar pelo fluxo completo de documentação,
implementação, testes e versionamento antes de ser exportado.

## Operações excluídas

| Operação | Motivo para exclusão |
| --- | --- |
| `PUT /material/v1/grupo/{codigo}` | Escrita fora do escopo somente leitura |
| `PUT /material/v1/classe/{codigo}` | Escrita fora do escopo somente leitura |
| `POST /material/v1/ncmPorCodigoItemMaterial` | Operação não `GET` fora do escopo |
| `POST /material/v1/materialFaseInterna` | Operação não `GET` fora do escopo |
| `POST /material/v1/grupo` | Escrita fora do escopo somente leitura |
| `POST /material/v1/classe` | Escrita fora do escopo somente leitura |

## Referências

- [Swagger da API CNBS](https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/)
- [Matriz da versão 0.1.0](matriz-material-0.1.0.md)
- [Decisão 0003 — Interface de características por PDM](../decisions/0003-interface-caracteristicas-pdm-0.1.1.md)
