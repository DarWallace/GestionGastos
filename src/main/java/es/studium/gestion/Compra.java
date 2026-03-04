package es.studium.gestion;

public class Compra {
	private int idCompra;
	private String fecha;
	private double importe;
	private String nombreTienda;

	public Compra(int idCompra, String fecha, double importe, String nombreTienda) {
		this.idCompra = idCompra;
		this.fecha = fecha;
		this.importe = importe;
		this.nombreTienda = nombreTienda;
	}

	// Getters
	public int getIdCompra() {
		return idCompra;
	}

	public String getFecha() {
		return fecha;
	}

	public double getImporte() {
		return importe;
	}

	public String getNombreTienda() {
		return nombreTienda;
	}

}
