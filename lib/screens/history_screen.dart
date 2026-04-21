import 'package:flutter/material.dart';
import '../models/history_entry.dart';
import '../services/history_service.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryEntry>? _history;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await HistoryService.getHistory();
    if (mounted) {
      setState(() {
        _history = history;
      });
    }
  }

  String _formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.t('history'),
          style: const TextStyle(
            fontFamily: 'NunitoTitle',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _history == null
          ? const Center(child: CircularProgressIndicator())
          : _history!.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: AppTheme.grayUnselected),
                  const SizedBox(height: 16),
                  Text(
                    "Aucun historique pour le moment",
                    style: TextStyle(color: AppTheme.grayUnselected),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history!.length,
              itemBuilder: (context, index) {
                final entry = _history![index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.darkGreen.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.hiking,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                    title: Text(
                      entry.trailName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${entry.startTime.day}/${entry.startTime.month} • ${_formatDuration(entry.elapsedSeconds)} • ${entry.pointsCount} pts",
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      onPressed: _isProcessing
                          ? null
                          : () async {
                              setState(() => _isProcessing = true);
                              await HistoryService.deleteEntry(entry.id);
                              if (mounted) {
                                setState(() => _isProcessing = false);
                                _loadHistory();
                              }
                            },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
