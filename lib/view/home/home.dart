import 'package:usettle/view/home/pending_invoice_card.dart';
import 'package:usettle/view/common/pages/general.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:usettle/view/home/summary_card.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends GeneralPageViewState<HomePage> {
  static const Color _greenColor = Color(0xFF2A6E55);

  @override
  String? getTitle() => null;

  @override
  Widget getBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/imgs/extended_logo.png',
                          height: 40,
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              const AssetImage('assets/imgs/goiana.jpeg'),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Faturas pendentes",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/history');
                          },
                          icon: const Text(
                            "Ver todas",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          label: PhosphorIcon(
                            PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
                            color: Colors.white70,
                            size: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        PendingInvoiceCard(
                          amount: "20 €",
                          date: "1 de maio 2025",
                          avatarUrls: const [
                            'assets/imgs/profile_pics/Andre.png',
                            'assets/imgs/profile_pics/Sofia.png',
                            'assets/imgs/profile_pics/Marcelo.png',
                          ],
                          location: "Restaurante XYZ",
                        ),
                        const SizedBox(width: 14.0),
                        PendingInvoiceCard(
                          amount: "15 €",
                          date: "1 de maio 2025",
                          avatarUrls: const [
                            'assets/imgs/profile_pics/Huang.png',
                            'assets/imgs/profile_pics/Tiago.jpg',
                          ],
                          location: "Café Central",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PhosphorIcon(
                        PhosphorIcons.chartPieSlice(PhosphorIconsStyle.fill),
                        size: 24,
                        color: _greenColor,
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        "Resumo contas",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: _buildBalanceCard(
                          context,
                          "Devem-me",
                          "42,30€",
                          [Colors.green.shade700, Colors.green.shade500],
                          PhosphorIcons.arrowCircleUp(PhosphorIconsStyle.fill),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: _buildBalanceCard(
                          context,
                          "Eu devo",
                          "14,00€",
                          [Colors.orange.shade700, Colors.orange.shade400],
                          PhosphorIcons.arrowCircleDown(
                              PhosphorIconsStyle.fill),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: "Pedir via",
                          amount: "Dívida Total",
                          peopleCount: 4,
                          actionText: "MBWay",
                          iconWidget: Image.asset(
                              'assets/imgs/mb-way-black.png',
                              height: 30,
                              width: 50,
                              fit: BoxFit.contain),
                          isOwedToUser: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: "Liquidar débitos",
                          amount: "14,00€",
                          peopleCount: 2,
                          actionText: "PAGAR",
                          iconWidget: PhosphorIcon(
                              PhosphorIcons.moneyWavy(
                                  PhosphorIconsStyle.duotone),
                              size: 30,
                              color: Colors.black87),
                          isOwedToUser: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Atividade recente",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Ver tudo",
                          style: TextStyle(
                            color: _greenColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildActivityItem(
                    "Sofia pagou 12,50€",
                    "Há 2 dias",
                    'assets/imgs/profile_pics/Sofia.png',
                    Colors.green.shade100,
                  ),
                  _buildActivityItem(
                    "Enviaste lembrete a Marcelo",
                    "Há 3 dias",
                    'assets/imgs/profile_pics/Marcelo.png',
                    Colors.blue.shade100,
                  ),
                  _buildActivityItem(
                    "Novo grupo criado: Jantar",
                    "Há 5 dias",
                    'assets/imgs/profile_pics/Tiago.jpg',
                    Colors.purple.shade100,
                  ),
                  const SizedBox(height: 50.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    PhosphorIconData iconData,
    String label,
    VoidCallback onTap,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: onTap,
              child: Center(
                child: PhosphorIcon(
                  iconData,
                  color: _greenColor,
                  size: 28.0,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(
    BuildContext context,
    String title,
    String amount,
    List<Color> gradientColors,
    PhosphorIconData iconData,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              PhosphorIcon(
                iconData,
                color: Colors.white,
                size: 24.0,
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5.0),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      String title, String time, String avatarUrl, Color bgColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: bgColor,
          radius: 24,
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(avatarUrl),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15.0,
          ),
        ),
        subtitle: Text(
          time,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13.0,
          ),
        ),
        trailing: PhosphorIcon(
          PhosphorIcons.caretRight(PhosphorIconsStyle.light),
          color: Colors.grey.shade400,
          size: 20.0,
        ),
      ),
    );
  }
}
