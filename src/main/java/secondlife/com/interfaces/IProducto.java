package secondlife.com.interfaces;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import secondlife.com.model.Producto;


public interface IProducto extends JpaRepository<Producto, String>{
	 
	    List<Producto> findByCateg(int categ);
	    
	    Producto findByProd(String id_prod);
	    
	    @Query(value="select * from tb_producto order by calidad desc limit 8", nativeQuery=true)
	    List<Producto> getProductosTop8ByCalidadDesc();
	    
	    @Query(value="select * from tb_producto t where t.id_categ = :categ and t.id_prod != :prod  ORDER BY calidad desc LIMIT 4", nativeQuery=true)
	    List<Producto> getProductosTop4ByCalidadDesc(int categ,String prod);
}
