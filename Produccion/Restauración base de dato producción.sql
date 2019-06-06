use master
go
restore database PedidosP
from disk= 'E:\Pedidos.bak'
with recovery, stats=10,
move 'pedidos1' to 'D:\Data\pedidosp1.mdf',
move 'pedidos2' to 'D:\Data\pedidosp2.ndf',
move 'pedidos1_log' to 'D:\Logs\pedidosp1.ldf'
go