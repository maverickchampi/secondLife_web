package secondlife.com.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import secondlife.com.interfaces.IProducto;
import secondlife.com.interfaces.IUsuario;
import secondlife.com.model.Producto;
import secondlife.com.model.Usuario;


@Controller
public class ProyectoController {
	/*-------------------------*/
	@Autowired
	private IProducto prod;

	@Autowired 
	private IUsuario iu;
	
	@Autowired 
    private PasswordEncoder passwordEncoder;

	/*-------------------------*/
	@GetMapping("/index")
	public String index(Model model) {
		model.addAttribute("lstProducto", prod.getProductosTop8ByCalidadDesc());
		return "index";
	}
	
	@GetMapping("/terminos")
	public String terminos() {
		return "terminos";
	}

	@GetMapping("/carrito")
	public String carrito() {
		return "carrito";
	}
	
	@GetMapping("/productos")
	public String productos(Model model) {
		model.addAttribute("lstProducto", prod.findAll());
		model.addAttribute("cantidad", prod.findAll().size()+" productos encontrados");
		return "productos";
	}
	
	@GetMapping("/productos/{id}")
	public String productosCateg(@PathVariable int id,Model model) {
		model.addAttribute("lstProducto", prod.findByCateg(id));
		model.addAttribute("cantidad",prod.findByCateg(id).size()+" productos encontrados");
		return "productos";
	}
	
	@GetMapping("/producto/{id}")
	public String producto(@PathVariable String id,Model model) {
		Producto p = prod.findByProd(id);
		model.addAttribute("producto", p);
		model.addAttribute("lstRecomendados", prod.getProductosTop4ByCalidadDesc(p.getCateg(),p.getProd()));
		return "producto";
	}
	
	
	
	@GetMapping("/bcrypt/{texto}")
	@ResponseBody
	public String encriptar(@PathVariable("texto")String texto) {
		return texto + " - encriptado en Bcrypt: "+passwordEncoder.encode(texto);
	}
	
	
	@GetMapping("/perfil")
	public String perfil() {
		return "perfil";
	}
	
	@GetMapping("/cotizar")
	public String cotizar() {
		return "cotizar";
	}
}
