"""Generate lib/design/icons.dart from the v1 SVG symbol library."""
import re

src = open(r'E:\projects\zchain_wallet\.dev\v1-icons.svg', encoding='utf-8').read()
symbols = re.findall(r'<symbol id="([^"]+)" viewBox="([^"]+)">([\s\S]*?)</symbol>', src)

lines = []
for sid, vb, inner in symbols:
    inner = re.sub(r'\s+', ' ', inner).strip()
    # 顶层 svg 显式声明描边;运行时用 ColorFilter.srcIn 着色
    svg = ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="{vb}" '
           'fill="none" stroke="#000000" stroke-width="1.6" '
           'stroke-linecap="square" stroke-linejoin="miter">{inner}</svg>'
           ).format(vb=vb, inner=inner)
    # Dart 字符串转义
    dart = svg.replace('\\', r'\\').replace("'", r"\'").replace('$', r'\$')
    lines.append("  '{id}': '{dart}',".format(id=sid, dart=dart))

body = '\n'.join(lines)

TEMPLATE = '''// GENERATED from design v1 symbol library (Pixso「设计文件」图标同源)。
// 每个图标为 24×24 stroke SVG;颜色运行时经 ColorFilter.srcIn 着色。
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 设计稿全部 stroke 图标(38 个 + qr-art 演示二维码)。
class ZcIcons {
  const ZcIcons._();

__BODY__

  /// 渲染图标;[size] 对应 .ic(18)/.ic-s(14)/.ic-xs(11)。
  static Widget icon(
    String id, {
    double size = 18,
    Color? color,
    double strokeWidth = 1.6,
  }) {
    final String? svg = _svg[id];
    assert(svg != null, '未知图标: $id');
    if (svg == null) return SizedBox(width: size, height: size);
    return SvgPicture.string(
      svg,
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(color ?? Colors.black, BlendMode.srcIn),
    );
  }
}
'''

# Dart 字典体(_svg 映射)单独拼装
dict_body = '  static const Map<String, String> _svg = {\n' + body + '\n  };'
out = TEMPLATE.replace('__BODY__', dict_body)
open(r'E:\projects\zchain_wallet\lib\design\icons.dart', 'w', encoding='utf-8').write(out)
print('icons.dart written:', len(symbols), 'symbols')
