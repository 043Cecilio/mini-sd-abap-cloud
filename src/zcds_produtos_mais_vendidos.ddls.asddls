@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Produtos Mais Vendidos - Mini SD'
define view entity zcds_produtos_mais_vendidos
  as select from zsd_pedido_itm as item
  inner join   zsd_produto    as prod on item.id_produto = prod.id_produto
{
  key item.id_produto,
      prod.descricao,
      prod.moeda,
      sum(item.quantidade)  as qtd_total_vendida,
      @Semantics.amount.currencyCode: 'moeda'
      sum(item.valor_total) as faturamento_total
}
group by
  item.id_produto,
  prod.descricao,
  prod.moeda
