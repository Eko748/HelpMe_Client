import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/send_order/send_order_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../../models/category_problem/problem_model.dart';
import '../../widgets/custom_dialog.dart';

class SelectProblemPage extends StatefulWidget {
  const SelectProblemPage({
    super.key,
    required this.categoryId,
    required this.category,
  });

  final int? categoryId;
  final String? category;

  @override
  State<SelectProblemPage> createState() => _SelectProblemPageState();
}

class _SelectProblemPageState extends State<SelectProblemPage> {
  List<ProblemModel> problems = [];
  ProblemModel? selectedProblem;

  @override
  void initState() {
    super.initState();
    context.read<SendOrderBloc>().add(ProblemsPop());
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: _appBar(context, textTheme),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              width: screenWidth,
              height: screenHeight / 5,
              child: Container(
                color: Colors.black,
                child: _detailHeadline(textTheme),
              ),
            ),
            Positioned(
              bottom: 100,
              width: screenWidth,
              height: screenHeight - (screenHeight / 2.45),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: _problemBlocConsumer(context, textTheme),
              ),
            ),
            Positioned(
              bottom: 0,
              width: screenWidth,
              height: screenHeight / 8,
              child: Container(
                color: AppColors.surface,
                child: BlocBuilder<SendOrderBloc, SendOrderState>(
                  builder: (context, state) {
                    if (state is OrderLoading || state is OrderError) {
                      return const SizedBox.shrink();
                    } else {
                      return _navigateSection(context, textTheme);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center _navigateSection(BuildContext context, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: _continueButton(context, textTheme),
        ),
      ),
    );
  }

  ElevatedButton _continueButton(BuildContext context, TextTheme textTheme) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: () {
        if (selectedProblem != null) {
          context.pushNamed(
            'addTaskPage',
            queryParameters: {
              'problemId': selectedProblem?.id.toString(),
              'problem': selectedProblem?.name.toString(),
            },
          );
        } else {
          CustomDialog.showAlertDialog(
            context,
            'Apa Masalahmu?',
            'Kasih tau masalah yang lagi kamu alamin sebelum nyari bantuan',
            null,
          );
        }
      },
      child: Text(
        'Lanjut detail',
        style: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.lightTextColor,
        ),
      ),
    );
  }

  BlocConsumer<SendOrderBloc, SendOrderState> _problemBlocConsumer(
    BuildContext context,
    TextTheme textTheme,
  ) {
    return BlocConsumer<SendOrderBloc, SendOrderState>(
      listener: (context, state) {
        if (state is ProblemsLoaded) {
          problems = state.problems;
        } else if (state is OrderError) {
          _stateError(context, state);
        }
      },
      builder: (context, state) {
        if (state is OrderInitial) {
          _onInitProblem(context, context);
        } else if (state is OrderLoading) {
          return const SizedBox.expand(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return ListView.builder(
          itemCount: problems.length,
          itemBuilder: (BuildContext context, int index) {
            ProblemModel data = problems[index];
            return Padding(
              padding: const EdgeInsets.all(8),
              child: _problemRadioTileList(data, context, textTheme),
            );
          },
        );
      },
    );
  }

  RadioListTile<ProblemModel> _problemRadioTileList(
    ProblemModel data,
    BuildContext context,
    TextTheme textTheme,
  ) {
    final title = data.name.toString();
    return RadioListTile<ProblemModel>(
      activeColor: AppColors.vividRed,
      fillColor: const WidgetStatePropertyAll(AppColors.salmonPink),
      title: Text(
        title.replaceFirst(title[0], title[0].toUpperCase()),
        style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold, color: AppColors.lightTextColor),
      ),
      value: data,
      groupValue: selectedProblem,
      contentPadding: const EdgeInsets.all(4),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
            color: AppColors.salmonPink,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside),
      ),
      onChanged: (value) {
        setState(() {
          selectedProblem = value as ProblemModel;
        });
        context.read<SendOrderBloc>().add(ProblemSelected(selectedProblem!));
      },
    );
  }

  void _onInitProblem(BuildContext contextBuilder, BuildContext context) {
    if (widget.categoryId != 0) {
      contextBuilder
          .read<SendOrderBloc>()
          .add(FetchProblems(problemName: widget.category!));
    } else {
      _categoryIdNotFound(contextBuilder);
    }
  }

  void _stateError(BuildContext context, OrderError state) {
    CustomDialog.showAlertDialog(
      context,
      'Error fetching problems',
      state.errorMessage,
      IconButton.outlined(
        onPressed: () {
          context.pop();
          context
              .read<SendOrderBloc>()
              .add(FetchProblems(problemName: widget.category!));
        },
        icon: const Icon(Icons.refresh_outlined),
      ),
    );
  }

  Widget _categoryIdNotFound(BuildContext context) {
    return CustomDialog.showAlertDialog(
      context,
      'Error',
      'Category tidak ada',
      ElevatedButton.icon(
        onPressed: () {
          context.pop();
          context.goNamed('homePage');
        },
        label: const Text('Kembali'),
        icon: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Padding _detailHeadline(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 30,
      ),
      child: Text.rich(
        softWrap: true,
        style: textTheme.headlineMedium?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
        widget.category?.toLowerCase().contains('serabutan') == false
            ? TextSpan(text: 'hmm, Kenapa\n${widget.category}mu?')
            : const TextSpan(text: 'hmm, Butuh \nbantuan apa kali ini?'),
      ),
    );
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      foregroundColor: AppColors.darkTextColor,
      title: Text(
        'Help Me!',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
