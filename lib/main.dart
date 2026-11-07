import 'package:flutter/material.dart';

void main() => runApp(const DraftyApp());

class Note {
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.updatedAt,
    this.isFavorite = false,
  });

  final int id;
  String title;
  String content;
  String category;
  DateTime updatedAt;
  bool isFavorite;
}

class DraftyApp extends StatelessWidget {
  const DraftyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xffe26d5a),
      brightness: Brightness.light,
    );
    return MaterialApp(
      title: 'Drafty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xfff8f6f2),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const DraftyHomePage(),
    );
  }
}

class DraftyHomePage extends StatefulWidget {
  const DraftyHomePage({super.key});

  @override
  State<DraftyHomePage> createState() => _DraftyHomePageState();
}

class _DraftyHomePageState extends State<DraftyHomePage> {
  final _searchController = TextEditingController();
  final _notes = <Note>[
    Note(
      id: 1,
      title: 'Ideas para el próximo proyecto',
      content: 'Explorar una interfaz más simple, cálida y rápida de usar.',
      category: 'Trabajo',
      updatedAt: DateTime(2026, 11, 6, 10, 30),
      isFavorite: true,
    ),
    Note(
      id: 2,
      title: 'Lista de compras',
      content: 'Café, pan de masa madre, tomates y algo dulce.',
      category: 'Personal',
      updatedAt: DateTime(2026, 11, 5, 18, 10),
    ),
    Note(
      id: 3,
      title: 'Lecturas pendientes',
      content: 'Revisar el artículo sobre creatividad y sistemas de diseño.',
      category: 'Inspiración',
      updatedAt: DateTime(2026, 11, 2, 9, 15),
    ),
  ];

  String _activeFilter = 'Todas';
  Note? _selectedNote;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Note> get _filteredNotes {
    final query = _searchController.text.trim().toLowerCase();
    return _notes.where((note) {
      final matchesFilter = _activeFilter == 'Todas' ||
          (_activeFilter == 'Favoritas' && note.isFavorite) ||
          note.category == _activeFilter;
      final matchesSearch = query.isEmpty ||
          note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
      return matchesFilter && matchesSearch;
    }).toList()..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  void _openEditor([Note? note]) {
    showDialog<void>(
      context: context,
      builder: (_) => NoteEditorDialog(
        note: note,
        onSave: (title, content, category) {
          setState(() {
            if (note == null) {
              final created = Note(
                id: DateTime.now().microsecondsSinceEpoch,
                title: title,
                content: content,
                category: category,
                updatedAt: DateTime.now(),
              );
              _notes.add(created);
              _selectedNote = created;
            } else {
              note.title = title;
              note.content = content;
              note.category = category;
              note.updatedAt = DateTime.now();
              _selectedNote = note;
            }
          });
        },
      ),
    );
  }

  void _deleteNote(Note note) {
    setState(() {
      _notes.remove(note);
      if (_selectedNote == note) _selectedNote = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        return Scaffold(
          appBar: compact
              ? AppBar(
                  title: const Text('Drafty'),
                  actions: [
                    IconButton(
                      onPressed: () => _openEditor(),
                      icon: const Icon(Icons.add),
                      tooltip: 'Nueva nota',
                    ),
                  ],
                )
              : null,
          body: SafeArea(
            child: Row(
              children: [
                if (!compact) _buildSidebar(),
                Expanded(child: _buildContent(compact)),
              ],
            ),
          ),
          floatingActionButton: compact
              ? FloatingActionButton(
                  onPressed: () => _openEditor(),
                  tooltip: 'Nueva nota',
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 240,
      padding: const EdgeInsets.fromLTRB(24, 28, 18, 20),
      decoration: const BoxDecoration(
        color: Color(0xfff1eee8),
        border: Border(right: BorderSide(color: Color(0xffe4dfd6))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.edit_note, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text('Drafty', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 34),
          FilledButton.icon(
            onPressed: () => _openEditor(),
            icon: const Icon(Icons.add, size: 19),
            label: const Text('Nueva nota'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              alignment: Alignment.centerLeft,
            ),
          ),
          const SizedBox(height: 26),
          _sidebarItem(Icons.inbox_outlined, 'Todas', _notes.length),
          _sidebarItem(Icons.star_border, 'Favoritas',
              _notes.where((note) => note.isFavorite).length),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 24, 12, 10),
            child: Text('CARPETAS', style: TextStyle(fontSize: 11, letterSpacing: 1.2)),
          ),
          _sidebarItem(Icons.work_outline, 'Trabajo', null),
          _sidebarItem(Icons.person_outline, 'Personal', null),
          _sidebarItem(Icons.lightbulb_outline, 'Inspiración', null),
          const Spacer(),
          const Text('Tus ideas, en un solo lugar', style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label, int? count) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        dense: true,
        selected: _activeFilter == label,
        selectedTileColor: const Color(0xffffddd4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Icon(icon, size: 20),
        title: Text(label),
        trailing: count == null ? null : Text('$count'),
        onTap: () => setState(() => _activeFilter = label),
      ),
    );
  }

  Widget _buildContent(bool compact) {
    final notes = _filteredNotes;
    return Padding(
      padding: EdgeInsets.fromLTRB(compact ? 18 : 46, compact ? 12 : 42, compact ? 18 : 46, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!compact) ...[
            Text('Mis notas', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text('Captura una idea antes de que se escape.', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 28),
          ],
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Buscar en tus notas...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.tune),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Text('${notes.length} notas', style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              if (compact)
                PopupMenuButton<String>(
                  onSelected: (value) => setState(() => _activeFilter = value),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'Todas', child: Text('Todas')),
                    PopupMenuItem(value: 'Favoritas', child: Text('Favoritas')),
                    PopupMenuItem(value: 'Trabajo', child: Text('Trabajo')),
                    PopupMenuItem(value: 'Personal', child: Text('Personal')),
                    PopupMenuItem(value: 'Inspiración', child: Text('Inspiración')),
                  ],
                  icon: const Icon(Icons.filter_list),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: notes.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    itemCount: notes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, index) => _buildNoteCard(notes[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    final selected = _selectedNote == note;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => setState(() => _selectedNote = note),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? const Color(0xfffff0eb) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? const Color(0xffe26d5a) : const Color(0xffebe7df)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 14),
                  Row(children: [
                    _categoryChip(note.category),
                    const SizedBox(width: 10),
                    Text(_formatDate(note.updatedAt), style: const TextStyle(color: Colors.black45, fontSize: 12)),
                  ]),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') _openEditor(note);
                if (value == 'delete') _deleteNote(note);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Editar')),
                PopupMenuItem(value: 'delete', child: Text('Eliminar')),
              ],
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(color: const Color(0xfff1eee8), borderRadius: BorderRadius.circular(7)),
      child: Text(category, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, size: 42, color: Color(0xffe26d5a)),
          const SizedBox(height: 14),
          Text('No hay notas aquí', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          const Text('Prueba otra búsqueda o crea una nota nueva.'),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays == 0) return 'Hoy';
    if (difference.inDays == 1) return 'Ayer';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class NoteEditorDialog extends StatefulWidget {
  const NoteEditorDialog({super.key, this.note, required this.onSave});

  final Note? note;
  final void Function(String title, String content, String category) onSave;

  @override
  State<NoteEditorDialog> createState() => _NoteEditorDialogState();
}

class _NoteEditorDialogState extends State<NoteEditorDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late String _category;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _category = widget.note?.category ?? 'Personal';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    widget.onSave(title, _contentController.text.trim(), _category);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.note == null ? 'Nueva nota' : 'Editar nota'),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _contentController,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(labelText: 'Escribe tu idea...'),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Carpeta'),
              items: const [
                DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                DropdownMenuItem(value: 'Trabajo', child: Text('Trabajo')),
                DropdownMenuItem(value: 'Inspiración', child: Text('Inspiración')),
              ],
              onChanged: (value) => setState(() => _category = value ?? 'Personal'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(onPressed: _save, child: const Text('Guardar')),
      ],
    );
  }
}