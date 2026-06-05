import csv
import random
from datetime import datetime, timedelta

# ==============================================================================
# PROYECTO: RETAIL FINANCIERO & LOGÍSTICA
# ARCHIVO: 00_data_generator.py
# OBJETIVO: Generar Modelo Estrella 
# ==============================================================================

print("Iniciando generación del Data Warehouse corporativo...")

# 1. LOCALES
regiones = [
    (1, 'Arica', 'Arica y Parinacota'), (2, 'Iquique', 'Tarapaca'), 
    (3, 'Antofagasta', 'Antofagasta'), (4, 'Copiapo', 'Atacama'), 
    (5, 'La Serena', 'Coquimbo'), (6, 'Valparaiso', 'Valparaiso'), 
    (7, 'Santiago Centro', 'Metropolitana'), (8, 'Rancagua', 'O Higgins'), 
    (9, 'Talca', 'Maule'), (10, 'Chillan', 'Nuble'), 
    (11, 'Concepcion', 'Biobio'), (12, 'Temuco', 'Araucania'), 
    (13, 'Valdivia', 'Los Rios'), (14, 'Puerto Montt', 'Los Lagos'), 
    (15, 'Coyhaique', 'Aysen'), (16, 'Punta Arenas', 'Magallanes')
]
with open('locales.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['id_local', 'nombre_local', 'region'])
    writer.writerows(regiones)

# 2. CLIENTES_CREDITO
clientes = []
estados = ['AL DIA', 'MOROSO', 'CASTIGADO', ' al dia ', 'MOROSO ']
for i in range(1, 2001):
    nombre = f"Cliente_{i}"
    if random.random() < 0.1: nombre = f"  {nombre.lower()}  " 
    
    dias_edad = random.randint(18*365, 70*365)
    fecha_nac = (datetime.now() - timedelta(days=dias_edad)).strftime('%Y-%m-%d')
    
    limite = round(random.uniform(200000, 3000000), 2)
    uso_credito = random.uniform(0.0, 0.95)
    deuda = round(limite * uso_credito, 2)
    
    if random.random() < 0.05: limite = '' 
    
    estado = random.choice(estados)
    clientes.append([i, nombre, fecha_nac, limite, deuda, estado])

with open('clientes_credito.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['id_cliente', 'nombre_completo', 'fecha_nacimiento', 'limite_credito', 'deuda_actual', 'estado_riesgo'])
    writer.writerows(clientes)

# 3. PRODUCTOS
productos = []
for i in range(1, 101):
    cat_rand = random.random()
    if cat_rand < 0.4:
        cat = 'Tecnologia'
        costo = round(random.uniform(50000, 600000), 2)
        precio = round(costo * 1.15, 2)
    elif cat_rand < 0.7:
        cat = 'Linea Blanca'
        costo = round(random.uniform(100000, 400000), 2)
        precio = round(costo * 1.30, 2)
    elif cat_rand < 0.9:
        cat = 'Muebles'
        costo = round(random.uniform(30000, 200000), 2)
        precio = round(costo * 2.50, 2)
    else:
        cat = 'Ferreteria'
        costo = round(random.uniform(10000, 150000), 2)
        precio = round(costo * 1.50, 2)
        
    productos.append([i, cat, f"Producto_{cat}_{i}", costo, precio])

with open('productos.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['id_producto', 'categoria', 'nombre_producto', 'costo_compra', 'precio_venta'])
    writer.writerows(productos)

# 4. INVENTARIO
inventario = []
id_inv = 1
for loc in regiones:
    for prod in productos:
        stock = random.randint(0, 300)
        inventario.append([id_inv, loc[0], prod[0], stock])
        id_inv += 1

with open('inventario.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['id_inventario', 'id_local', 'id_producto', 'stock_disponible'])
    writer.writerows(inventario)

# 5 & 6. TRANSACCIONES Y DETALLE
transacciones = []
detalles = []
id_det = 1

# Tipos de pago definidos corporativamente
tipos_pago = ['Credito Tienda', 'Debito', 'Efectivo', ' debito ', 'CREDITO TIENDA']

for id_trans in range(1001, 6001): 
    id_loc = random.randint(1, 16)
    id_cli = random.randint(1, 2000) if random.random() > 0.1 else ''
    
    num_items = random.randint(1, 4)
    monto_total = 0
    for _ in range(num_items):
        prod_seleccionado = random.choice(productos)
        id_prod = prod_seleccionado[0]
        precio_vta = prod_seleccionado[4] 
        cantidad = random.randint(1, 3)
        subtotal = round(precio_vta * cantidad, 2)
        
        monto_total += subtotal
        detalles.append([id_det, id_trans, id_prod, cantidad, subtotal])
        id_det += 1
        
    monto_total = round(monto_total, 2)

    fecha_obj = datetime(2025, random.randint(1, 12), random.randint(1, 28))
    rand_fmt = random.random()
    if rand_fmt < 0.7: fecha = fecha_obj.strftime('%Y-%m-%d')
    elif rand_fmt < 0.8: fecha = fecha_obj.strftime('%d/%m/%Y')
    elif rand_fmt < 0.9: fecha = fecha_obj.strftime('%d-%m-%Y')
    else: fecha = '18 mayo 25'
        
    # Lógica de cuotas basada en tu sugerencia
    pago = random.choice(tipos_pago)
    if 'credito tiend' in pago.lower():
        cuotas = random.choice([3, 6, 12, 24])
    else:
        cuotas = 1
        
    transacciones.append([id_trans, id_loc, id_cli, fecha, monto_total, pago, cuotas])

with open('transacciones.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['id_transaccion', 'id_local', 'id_cliente', 'fecha_venta', 'monto_total', 'tipo_pago', 'cantidad_cuotas'])
    writer.writerows(transacciones)

with open('detalle_transacciones.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['id_detalle', 'id_transaccion', 'id_producto', 'cantidad', 'subtotal'])
    writer.writerows(detalles)

print("¡Éxito! 6 archivos CSV generados matemáticamente cuadrados e incluyendo cuotas.")
