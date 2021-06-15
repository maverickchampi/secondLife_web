package secondlife.com.controller;

import java.security.Principal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

import secondlife.com.interfaces.IBoleta;
import secondlife.com.interfaces.IDetalleBoleta;
import secondlife.com.interfaces.IDireccion;
import secondlife.com.interfaces.IDistrito;
import secondlife.com.interfaces.IProducto;
import secondlife.com.interfaces.ITarjeta;
import secondlife.com.interfaces.IUsuario;
import secondlife.com.model.Boleta;
import secondlife.com.model.Carrito;
import secondlife.com.model.DetalleBoleta;
import secondlife.com.model.Direccion;
import secondlife.com.model.Producto;
import secondlife.com.model.Tarjeta;
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
	private IDistrito idis;
	
	@Autowired
	private IDireccion idir;
	
	@Autowired
	private ITarjeta it;

	@Autowired
	private IBoleta ib;
	
	@Autowired
	private IDetalleBoleta idb;
	
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
	
	@PostMapping("/perfil")
	public String postPerfil(Usuario u,Model model) {
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
		
		Usuario user = iu.findByUsuario(auto.getName());
		if(u.getNom_usua().length() > 2) {
			user.setNom_usua(u.getNom_usua());
		}
		if(u.getApe_usua().length() > 2) {
			user.setApe_usua(u.getApe_usua());
		}
		if(u.getDni_usua().length() == 8) {
			user.setDni_usua(u.getDni_usua());
		}
		
		user.setFec_nac_usua(u.getFec_nac_usua());
		
		if(u.getTel_usua().length() == 9) {
			user.setTel_usua(u.getTel_usua());
		}
		if(u.getEmail_log().length() > 10) {
			user.setEmail_log(u.getEmail_log());
		}
		if(u.getUsuario().length() > 7) {
			user.setUsuario(u.getUsuario());
		}
		if(u.getPass().length() > 7) {
			user.setPass(passwordEncoder.encode(u.getPass()));
		}
		
		iu.save(user);
		
		model.addAttribute("carrito", carrito);
		model.addAttribute("user", user);
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

	@GetMapping("/pago")
	public String postPago( Model model, @ModelAttribute("carrito")ArrayList<DetalleBoleta> carrito) {
		if(carrito.size() == 0) {
			return "redirect:/carrito";
		}
		
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
		
		Usuario u = iu.findByUsuario(auto.getName());

		model.addAttribute("verCarrito", verCarrito);
		model.addAttribute("tarjetas",it.findByUsuari(u.getId_usua()));
		model.addAttribute("direcciones",idir.findByUsuar(u.getId_usua()));
		model.addAttribute("distritos",idis.findAll());
		model.addAttribute("total", total);
		model.addAttribute("user", u);
		model.addAttribute("carrito", carrito);
		return "pago";
	}
	
	@Transactional
	@PostMapping("/pago")
	public String pagoPost(Boleta bol, Model model,@ModelAttribute("carrito")ArrayList<DetalleBoleta> carrito) {
		bol.setNum_bol("");
		bol.setTipo_pago(1);
		
		Date date = new Date();
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		bol.setFec_bol(dateFormat.format(date));
		bol.setEnvio(0);
		bol.setTotal_bol(bol.getImpo_bol() + bol.getEnvio());
		
		ib.save(bol);
		
		String codigoBoleta = ib.getLastNum(bol.getUsua());
		
		for(DetalleBoleta db : carrito) {
			Producto p = ip.findByProd(db.getProbBole());
			
			db.setNum_bol(codigoBoleta);
			db.setNum_det_bol("");
			db.setSub_tot(db.getCant_prod() * p.getPrecio());
			
			idb.save(db);
		}
		
		Iterator<DetalleBoleta> productosIterator = carrito.iterator();
        while (productosIterator.hasNext()) {
        	productosIterator.next();
            productosIterator.remove();
        }
        
		model.addAttribute("carrito", carrito);
		return "redirect:/pago";
	}
	
	@PostMapping("/direccionPago")
	public String direccionPago(Direccion dir,Model model) {
		dir.setId_direc("");
		dir.setLatitud(0);
		dir.setLongitud(0);
		idir.save(dir);
		model.addAttribute("carrito", carrito);
		return "redirect:/pago";
	}
	
	@PostMapping("/tarjetaPago")
	public String tarjetaPago(Tarjeta tar,Model model) {
		tar.setId_tarj("");
		
		String tarjeta ="";
		if(tar.getNum_tarj().charAt(0) == '4') {
			tarjeta="Visa";
		}else if (tar.getNum_tarj().charAt(0) == '5') {
			tarjeta= "Mastercard";
		}else {
			tarjeta="Desconocido";
		}
		tar.setTip_tarj(tarjeta);
		
		it.save(tar);
		model.addAttribute("carrito", carrito);
		return "redirect:/pago";
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
