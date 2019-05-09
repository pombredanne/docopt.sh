from .. import Function
from ...bash_helper import bash_name, bash_value


class Defaults(Function):
  def __init__(self, sorted_params, name_prefix):
    super(Defaults, self).__init__('defaults')
    self.sorted_params = sorted_params
    self.name_prefix = name_prefix

  def include(self):
    return len(self.sorted_params) > 0

  def __str__(self):
    defaults = [
      "[[ -z ${{{name}+x}} ]] && {name}={default}".format(name=bash_name(p.name, self.name_prefix), default=bash_value(p.value))
      if type(p.value) is list else
      "{name}=${{{name}:-{default}}}".format(name=bash_name(p.name, self.name_prefix), default=bash_value(p.value))
      for p in self.sorted_params
    ]
    script = '\n'.join(defaults)
    return self.fn_wrap(script)