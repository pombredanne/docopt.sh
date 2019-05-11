from .. import Function, bash_value


class Node(Function):
  def __init__(self, settings, name, function, args):
    super(Node, self).__init__(settings, name)
    self.function = function
    self.args = args

  def __str__(self):
    script = ' '.join([self.function] + [bash_value(arg) for arg in self.args])
    return self.fn_wrap(script)