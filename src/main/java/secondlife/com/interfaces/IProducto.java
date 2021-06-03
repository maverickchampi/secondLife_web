package secondlife.com.interfaces;

import org.springframework.data.jpa.repository.JpaRepository;

import secondlife.com.model.Producto;


public interface IProducto extends JpaRepository<Producto, String>{
}
