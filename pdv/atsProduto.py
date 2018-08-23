# -*- encoding: utf-8 -*-

import odoorpc
from datetime import datetime
from datetime import date
from datetime import timedelta
import atscon as con
import re

class AtsProduto:

    ######## IMPORTAR PRODUTOS
    def produtos(self):
        # vendo se a categoria está cadastrada
        #odoo = self.con()
        #import pdb; pdb.set_trace()
        db = con.Conexao()
        sist = db.sistema()
        
        #order = odoo.env['pos.order']
        hj = datetime.now()
        hj = hj - timedelta(days=220)
        hj = datetime.strftime(hj,'%Y-%m-%d %H:%M:%S')
        
        grupo = sist.env['pos.category']
        grupo_ids = grupo.search([('create_date', '>=', hj),('parent_id','!=', False)])
        for grp in grupo.browse(grupo_ids):
            sqlp = 'SELECT a.COD_CATEGORIA, a.COD_FAMILIA FROM CATEGORIAPRODUTO a where a.COD_CATEGORIA = %s' %(grp.id)
            grps = db.query(sqlp)
            if not len(grps):
                # procura a familia
                sqlp = 'SELECT a.COD_FAMILIA FROM FAMILIAPRODUTOS a where a.cod_Familia = %s' %(grp.parent_id.id)
                frps = cur.query(sqlp)
                if not len(frps):
                    insere = 'INSERT INTO FAMILIAPRODUTOS (DESCFAMILIA, COD_FAMILIA) VALUES (\'%s\',%s)'\
                        %(grp.parent_id.name, grp.parent_id.id)
                    db.insert(insere)

                insere = 'INSERT INTO CATEGORIAPRODUTO (DESCCATEGORIA, COD_CATEGORIA, COD_FAMILIA) VALUES (\
                         \'%s\',%s, %s);' %(grp.name, grp.id, grp.parent_id.id)
                db.insert(insere)

        prod_ids = sist.env['product.product'].search([
           ('create_date', '>=', hj),
           ('sale_ok', '=', True)])
        for product_id in sist.env['product.product'].browse(prod_ids):
            sqlp = 'select codproduto from produtos where codproduto = %s' %(product_id.id)
            prods = db.query(sqlp)
            if not len(prods):
                #import pudb;pu.db
                print (product_id.name)
                cat = ''
                if product_id.pos_categ_id:
                    cat = product_id.pos_categ_id.name
                fam = ''
                if product_id.pos_categ_id.parent_id:
                    fam = product_id.pos_categ_id.parent_id.name
                ncm = ''
                if product_id.fiscal_classification_id:
                    ncm = product_id.fiscal_classification_id.code
                    ncm = re.sub('[^0-9]', '', ncm)
                p_custo = 0.0
                if product_id.standard_price:
                    p_custo = product_id.standard_price
                p_venda = 0.0
                if product_id.list_price:
                    p_venda = product_id.list_price
                codp = str(product_id.id)
                if product_id.default_code:
                    codp = product_id.default_code
                insere = 'INSERT INTO PRODUTOS (CODPRODUTO, UNIDADEMEDIDA, PRODUTO, PRECOMEDIO, CODPRO,\
                          TIPOPRECOVENDA, ORIGEM, NCM, VALORUNITARIOATUAL, VALOR_PRAZO, TIPO'
                if fam:
                    insere += ', FAMILIA'
                if cat:
                    insere += ', CATEGORIA'
                insere += ') VALUES ('
                insere += str(product_id.id)
                insere += ', \'' + str(product_id.uom_id.name.encode('ascii', 'ignore')) + '\''
                insere += ', \'' + str(product_id.name.encode('ascii', 'ignore')) + '\''
                insere += ',' + str(p_custo)
                insere += ', \'' + str(codp) + '\''
                insere += ',\'F\''
                insere += ',' + str(product_id.origin)
                insere += ',\'' + str(ncm) + '\''
                insere += ',' + str(p_custo)
                insere += ',' + str(p_venda)
                insere += ',\'' + str('PROD') + '\''
                if fam:
                    insere += ', \'' + str(fam) + '\''
                if cat:
                    insere += ', \'' + str(cat) + '\''
                insere += ')'
                print (codp+'-'+product_id.name)
                # print ' Cadastrando : %s - %s' % (str(row[0]), row[1])
                db.insert(insere)

p = AtsProduto()
p.produtos()
