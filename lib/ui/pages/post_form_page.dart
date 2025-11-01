import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/posts/post_bloc.dart';
import '../../bloc/posts/post_event.dart';
import '../../bloc/posts/post_state.dart';
import '../../model/post.dart';

class PostFormPage extends StatefulWidget {
  const PostFormPage({super.key});

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  Post? _existingPost;
  bool _isEditMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null) {
      _existingPost = arguments as Post;
      _isEditMode = true;
      _titleController.text = _existingPost!.title;
      _bodyController.text = _existingPost!.body;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final body = _bodyController.text;

      if (_isEditMode) {
        context.read<PostBloc>().add(
          PostUpdated(id: _existingPost!.id, title: title, body: body),
        );
      } else {
        context.read<PostBloc>().add(PostAdded(title: title, body: body));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.redAccent;
    final backgroundColor = Colors.grey.shade100;

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostOperationSuccess) {
              Navigator.of(context).pop();
            } else if (state is PostOperationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Error: ${state.error.replaceFirst('Exception: ', '')}',
                  ),
                  backgroundColor: primaryColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCustomHeader(context, _isEditMode),
                  const SizedBox(height: 32),

                  _buildModernTextFormField(
                    context: context,
                    controller: _titleController,
                    labelText: 'Title',
                    prefixIcon: Icons.title,
                    validator: (value) =>
                        value!.isEmpty ? 'Title tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildModernTextFormField(
                    context: context,
                    controller: _bodyController,
                    labelText: 'Body',
                    prefixIcon: Icons.article_outlined,
                    maxLines: 8,
                    validator: (value) =>
                        value!.isEmpty ? 'Body tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 32),

                  BlocBuilder<PostBloc, PostState>(
                    builder: (context, state) {
                      final isLoading = state is PostOperationInProgress;
                      return ElevatedButton(
                        onPressed: isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          shadowColor: primaryColor.withOpacity(0.3),
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                _isEditMode ? 'UPDATE' : 'SIMPAN',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, bool isEditMode) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(width: 16),

        Text(
          isEditMode ? 'Edit Post' : 'Tambah Post',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildModernTextFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          alignLabelWithHint: maxLines > 1 ? true : false,

          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          hintStyle: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
