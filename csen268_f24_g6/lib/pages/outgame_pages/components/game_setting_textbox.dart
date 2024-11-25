import 'package:flutter/material.dart';
import 'text_styles.dart';

class GameSettingTextBox extends StatefulWidget {
  final bool gameSettingsMode;

  const GameSettingTextBox({super.key, required this.gameSettingsMode});

  @override
  _GameSettingTextBoxState createState() => _GameSettingTextBoxState();
}

class _GameSettingTextBoxState extends State<GameSettingTextBox> {
  double killers = 2;
  double doctors = 1;
  double innocents = 3;
  double timePerRound = 30;

  @override
  Widget build(BuildContext context) {
    // List of settings
    List<Map<String, dynamic>> settings = [
      {
        'label': 'Killers', 'value': killers,
        'maxValue': 3.0, 'minValue': 1.0,
        'onChanged': (value) => setState(() => killers = value)
      },
      {
        'label': 'Doctors', 'value': doctors,
        'maxValue': 2.0, 'minValue': 1.0,
        'onChanged': (value) => setState(() => doctors = value)
      },
      {
        'label': 'Innocents', 'value': innocents,
        'maxValue': 5.0, 'minValue': 1.0,
        'onChanged': (value) => setState(() => innocents = value)
      },
      {
        'label': 'Time Per Round (s)', 'value': timePerRound,
        'maxValue': 60.0, 'minValue': 10.0,
        'onChanged': (value) => setState(() => timePerRound = value)
      },
    ];

    return Container(
      width: widget.gameSettingsMode ? 500 : 300,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget.gameSettingsMode // Check if scrolling is enabled
          ? Scrollbar(
              thumbVisibility: true,
              thickness: 6.0,
              radius: const Radius.circular(10),
              child: Center(
                child: SingleChildScrollView( // Enable scrolling
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   'Game Settings',
                      //   style: customTextStyle(30),
                      //   textAlign: TextAlign.center,
                      // ),
                      // const SizedBox(height: 16),
                      for (var setting in settings)
                        _buildSettingRow(
                          setting['label'],
                          setting['value'],
                          setting['maxValue'],
                          setting['minValue'],
                          widget.gameSettingsMode,
                          setting['onChanged'],
                        ),
                    ],
                  ),
                ),
              ),
            )
          : Column( // Non-scrollable content
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Game Settings',
                  style: customTextStyle(30),
                  textAlign: TextAlign.center,
                ),
                for (var setting in settings)
                  _buildSettingRow(
                    setting['label'],
                    setting['value'],
                    setting['maxValue'],
                    setting['minValue'],
                    widget.gameSettingsMode,
                    setting['onChanged'],
                  ),
              ],
            ),
    );
  }

  Widget _buildSettingRow(
    String label,
    double value,
    double maxValue,
    double minValue,
    bool showSlider,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$label: ${value.toInt()}',
          style: customTextStyle(16),
        ),
        if (showSlider)
          Slider(
            value: value,
            min: minValue,
            max: maxValue,
            divisions: (maxValue - minValue).toInt(),
            onChanged: onChanged,
            activeColor: Colors.white,
            inactiveColor: Colors.grey,
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
