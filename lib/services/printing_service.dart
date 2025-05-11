import 'dart:io';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

class PrintingService {
  final String printerIp;
  final int port;

  PrintingService({required this.printerIp, this.port = 9100});

  Future<void> printSimpleTicket() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final bytes = <int>[];

    bytes.addAll(generator.text('Ticket de test',
        styles: const PosStyles(align: PosAlign.center, bold: true)));
    bytes.addAll(generator.text('Merci et à bientôt!'));
    bytes.addAll(generator.cut());

    final socket = await Socket.connect(printerIp, port);
    socket.add(Uint8List.fromList(bytes));
    await socket.flush();
    await socket.close();
  }
}
