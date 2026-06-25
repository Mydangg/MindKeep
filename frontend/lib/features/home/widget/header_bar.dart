import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderBar({super.key, this.username, this.avatarUrl});

  final String? username;
  final String? avatarUrl;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12, top: 5, bottom: 5),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image:
                    avatarUrl != null && avatarUrl!.startsWith('http')
                        ? NetworkImage(avatarUrl!)
                        : AssetImage(
                              (avatarUrl?.isNotEmpty ?? false)
                                  ? avatarUrl!
                                  : 'assets/images/user.jpg',
                            )
                            as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        titleSpacing: 18,
        title: Text(
          username ?? 'Cập nhập....',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        // actions: [
        //   Container(
        //     decoration: BoxDecoration(
        //       border: Border.all(color: AppColors.greyscale200),
        //       shape: BoxShape.circle,
        //     ),
        //     child: Padding(
        //       padding: const EdgeInsets.all(8),
        //       child: GestureDetector(
        //         onTap: () {},
        //         child: SvgPicture.asset(
        //           'assets/icons/Search.svg',
        //           width: 20,
        //           height: 20,
        //         ),
        //       ),
        //     ),
        //   ),
        //   const SizedBox(width: 20),
        // ],
      ),
    );
  }
}
