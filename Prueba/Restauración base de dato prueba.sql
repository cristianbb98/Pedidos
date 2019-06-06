use master
go
restore database PedidosP
from disk= 'E:\Pedidos.bak'
with recovery, stats=10,
move 'pedidos1' to 'E:\DataP\pedidosp1.mdf',
move 'pedidos2' to 'E:\DataP\pedidosp2.ndf',
move 'pedidos1_log' to 'E:\LogsP\pedidosp1.ldf'
go