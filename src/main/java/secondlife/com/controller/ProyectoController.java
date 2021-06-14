package secondlife.com.controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.SessionAttributes;
import secondlife.com.interfaces.IProducto;
import secondlife.com.interfaces.IUsuario;
import secondlife.com.model.Carrito;
import secondlife.com.model.DetalleBoleta;
import secondlife.com.model.Producto;
import secondlife.com.model.Usuario;

@Controller
@SessionAttributes({ "user", "carrito", "Usuario" })

public class ProyectoController {
	/*-------------------------*/
	@Autowired
	private IProducto ip;

	@Autowired
	private IUsuario iu;

	@Autowired
	private PasswordEncoder passwordEncoder;

	ArrayList<DetalleBoleta> carrito = new ArrayList<DetalleBoleta>();

	/*-------------------------*/
	@GetMapping({ "/", "/index" })
	public String index(Model model) {
		model.addAttribute("carrito", carrito);
		model.addAttribute("lstProducto", ip.getProductosTop8ByCalidadDesc());
		return "index";
	}

	@PostMapping({ "/", "/index" })
	public String postIndex(DetalleBoleta producto,Model model,@ModelAttribute("carrito")ArrayList<DetalleBoleta> carrito) {
		boolean bandera = false;
		
		for(DetalleBoleta db : carrito) {
			if(db.getProbBole().equals(producto.getProbBole())) {
				db.setCant_prod(db.getCant_prod()+1);
				bandera = true;
			}
		}
		
		if(bandera == false) {
			producto.setCant_prod(1);
			carrito.add(producto);
		}

		model.addAttribute("carrito", carrito);
		model.addAttribute("lstProducto", ip.getProductosTop8ByCalidadDesc());
		return "index";
	}
	
	@GetMapping("/terminos")
	public String terminos(Model model) {
		model.addAttribute("carrito", carrito);
		return "terminos";
	}

	@GetMapping("/carrito")
	public String carrito(Model model,@ModelAttribute("carrito")ArrayList<DetalleBoleta> carrito) {
		double total = 0;
		
		ArrayList<Carrito> verCarrito = new ArrayList<Carrito>();
		for(DetalleBoleta db : carrito) {
			Producto p = ip.findByProd(db.getProbBole());
			Carrito c = new Carrito();
			c.setCodigo(p.getProd());
			c.setDescripcion(p.getMod_prod());
			c.setMarca(p.getMar_prod());
			c.setImagen(p.getImage());
			c.setPrecio(p.getPrecio());
			c.setCantidad(db.getCant_prod());
			c.setSubtotal(c.getPrecio() * c.getCantidad());
			total += c.getSubtotal();
			verCarrito.add(c);
		}
		model.addAttribute("carrito", carrito);
		model.addAttribute("verCarrito", verCarrito);
		model.addAttribute("total", total);
		return "carrito";
	}
	@PostMapping("/carrito")
	public String postCarrito(DetalleBoleta deletedb,Model model,@ModelAttribute("carrito")ArrayList<DetalleBoleta> carrito) {
		double total = 0;
		
		
		Iterator<DetalleBoleta> productosIterator = carrito.iterator();
        while (productosIterator.hasNext()) {
        	DetalleBoleta producto = productosIterator.next();
            if (producto.getProbBole().equals(deletedb.getProbBole())) {
                productosIterator.remove();
            }
        }
        
        ArrayList<Carrito> verCarrito = new ArrayList<Carrito>();
		for(DetalleBoleta db : carrito) {
			Producto p = ip.findByProd(db.getProbBole());
			Carrito c = new Carrito();
			c.setCodigo(p.getProd());
			c.setDescripcion(p.getMod_prod());
			c.setMarca(p.getMar_prod());
			c.setImagen(p.getImage());
			c.setPrecio(p.getPrecio());
			c.setCantidad(db.getCant_prod());
			c.setSubtotal(c.getPrecio() * c.getCantidad());
			total += c.getSubtotal();
			verCarrito.add(c);
		}
		model.addAttribute("carrito", carrito);
		model.addAttribute("verCarrito", verCarrito);
		model.addAttribute("total", total);
		return "carrito";
	}

	@GetMapping("/productos")
	public String productos(Model model) {
		model.addAttribute("carrito", carrito);
		model.addAttribute("lstProducto", ip.findAll());
		model.addAttribute("cantidad", ip.findAll().size() + " productos encontrados");
		return "productos";
	}
	
	@PostMapping("/productos")
	public String postProductos(DetalleBoleta producto,Model model,@ModelAttribute("carrito")ArrayList<DetalleBoleta> carrito) {
		boolean bandera = false;
		
		for(DetalleBoleta db : carrito) {
			if(db.getProbBole().equals(producto.getProbBole())) {
				db.setCant_prod(db.getCant_prod()+1);
				bandera = true;
			}
		}
		
		if(bandera == false) {
			producto.setCant_prod(1);
			carrito.add(producto);
		}
		model.addAttribute("carrito", carrito);
		model.addAttribute("lstProducto", ip.findAll());
		model.addAttribute("cantidad", ip.findAll().size() + " productos encontrados");
		return "productos";
	}

	@GetMapping("/productos/{id}")
	public String productosCateg(@PathVariable int id, Model model) {
		model.addAttribute("carrito", carrito);
		model.addAttribute("lstProducto", ip.findByCateg(id));
		model.addAttribute("cantidad", ip.findByCateg(id).size() + " productos encontrados");
		return "productos";
	}

	@GetMapping("/producto/{id}")
	public String producto(@PathVariable String id, Model model) {
		Producto p = ip.findByProd(id);
		model.addAttribute("carrito", carrito);
		model.addAttribute("producto", p);
		model.addAttribute("lstRecomendados", ip.getProductosTop4ByCalidadDesc(p.getCateg(), p.getProd()));
		return "producto";
	}
	
	@PostMapping("/producto")
	public String postProducto(DetalleBoleta producto,Model model,@ModelAttribute("carrito")ArrayList<DetalleBoleta> carrito) {
		
		boolean bandera = false;
		
		for(DetalleBoleta db : carrito) {
			if(db.getProbBole().equals(producto.getProbBole())) {
				db.setCant_prod(db.getCant_prod()+producto.getCant_prod());
				bandera = true;
			}
		}
		
		if(bandera == false) {
			carrito.add(producto);
		}

		model.addAttribute("carrito", carrito);
		return "redirect:/productos";
	}

	@GetMapping("/perfil")
	public String perfil(Model model) {
		SecurityContext context = SecurityContextHolder.getContext();
		Authentication auto = context.getAuthentication();
		if (auto == null) {
			return "index";
		} else {
			Collection<? extends GrantedAuthority> authorities = auto.getAuthorities();

			for (GrantedAuthority a : authorities) {
				System.out.println(auto.getName());
				System.out.println(a.getAuthority());
			}
		}
		model.addAttribute("carrito", carrito);
		model.addAttribute("user", iu.findByUsuario(auto.getName()));
		return "perfil";
	}

	@GetMapping("/login")
	public String login( Model model, Principal principal) {
		if (principal != null) {
			return "redirect:/perfil";
		}
		model.addAttribute("carrito", carrito);
		model.addAttribute("carrito", carrito);
		return "login";
	}

	@GetMapping("/registrar")
	public String registrar(Model model, Principal principal) {
		if (principal != null) {
			return "redirect:/perfil";
		}
		model.addAttribute("carrito", carrito);
		return "registrar";
	}

	@PostMapping("/registrar")
	public String registrarPost(Usuario u, Model model) {
		u.setPass(passwordEncoder.encode(u.getPass()));
		u.setId_usua("");
		u.setEstado(1);
		u.setId_rol(4);
		iu.save(u);
		model.addAttribute("carrito", carrito);
		return "registrar";
	}

	@GetMapping("/cotizar")
	public String cotizar( Model model) {
		model.addAttribute("carrito", carrito);
		return "cotizar";
	}

	@GetMapping("/admin")
	public String admin( Model model) {
		model.addAttribute("carrito", carrito);
		return "admin";
	}

}
