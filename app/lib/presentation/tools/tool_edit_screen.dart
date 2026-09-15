import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:werkzeugkiste/domain/exceptions.dart";
import "package:werkzeugkiste/domain/tool.dart";

import "../../application/loan_workflow_controller.dart";

/// Erstellt ein neues Werkzeug (falls [tool] `null` ist) oder bearbeitet ein
/// bestehendes (Lastenheft Abschnitt 10, nur der Eigentümer darf bearbeiten
/// – wird von der Domain-Schicht erzwungen, siehe `tool_service.updateTool`).
class ToolEditScreen extends ConsumerStatefulWidget {
  const ToolEditScreen({super.key, required this.communityId, this.tool});

  final String communityId;
  final Tool? tool;

  @override
  ConsumerState<ToolEditScreen> createState() => _ToolEditScreenState();
}

class _ToolEditScreenState extends ConsumerState<ToolEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _category;
  late final TextEditingController _model;
  late final TextEditingController _description;
  late final TextEditingController _condition;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final tool = widget.tool;
    _name = TextEditingController(text: tool?.name ?? "");
    _category = TextEditingController(text: tool?.category ?? "");
    _model = TextEditingController(text: tool?.model ?? "");
    _description = TextEditingController(text: tool?.description ?? "");
    _condition = TextEditingController(text: tool?.condition ?? "");
  }

  @override
  void dispose() {
    _name.dispose();
    _category.dispose();
    _model.dispose();
    _description.dispose();
    _condition.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final controller = ref.read(loanWorkflowControllerProvider);
    try {
      if (widget.tool == null) {
        await controller.createTool(
          communityId: widget.communityId,
          name: _name.text.trim(),
          category: _category.text.trim(),
          model: _model.text.trim().isEmpty ? null : _model.text.trim(),
          description: _description.text.trim().isEmpty ? null : _description.text.trim(),
          condition: _condition.text.trim().isEmpty ? null : _condition.text.trim(),
        );
      } else {
        await controller.editTool(
          widget.tool!,
          name: _name.text.trim(),
          category: _category.text.trim(),
          model: _model.text.trim().isEmpty ? null : _model.text.trim(),
          description: _description.text.trim().isEmpty ? null : _description.text.trim(),
          condition: _condition.text.trim().isEmpty ? null : _condition.text.trim(),
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        final message = e is DomainException ? e.message : "$e";
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.tool != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Werkzeug bearbeiten" : "Neues Werkzeug")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: "Name *"),
              validator: (v) => (v == null || v.trim().isEmpty) ? "Pflichtfeld" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _category,
              decoration: const InputDecoration(labelText: "Kategorie *"),
              validator: (v) => (v == null || v.trim().isEmpty) ? "Pflichtfeld" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _model,
              decoration: const InputDecoration(labelText: "Modell (optional)"),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _condition,
              decoration: const InputDecoration(labelText: "Zustand (optional)"),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(labelText: "Beschreibung (optional)"),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(isEditing ? "Speichern" : "Erstellen"),
            ),
          ],
        ),
      ),
    );
  }
}
