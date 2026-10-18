History auto-sync
-----------------

Bash-it reads extra tokens from ``HISTCONTROL`` (colon-separated, matched exactly)
to keep the history of several running shells in sync.
The hooks are installed by ``lib/history.bash``:

- auto-save runs from ``preexec``, so it happens **before** each command runs.
- auto-load runs from ``PROMPT_COMMAND``, so it happens **after** each command.

=================  ===========================================  ==========================================
Token              Before each command (auto-save)              After each command (auto-load)
=================  ===========================================  ==========================================
``noauto``         nothing                                      nothing
``autosave``       append new lines to ``$HISTFILE``            append new lines to ``$HISTFILE``
``autoload``       nothing                                      append, clear, re-read ``$HISTFILE``
``autoloadnew``    nothing                                      read lines new in ``$HISTFILE``
``autoshare``      append new lines to ``$HISTFILE``            append, clear, re-read ``$HISTFILE``
(none)             append only if ``shopt histappend`` is set   nothing
=================  ===========================================  ==========================================

Other ``HISTCONTROL`` tokens such as ``ignorespace`` or ``erasedups`` are unaffected.

Precedence
~~~~~~~~~~

If several tokens are present, the first matching rule below applies:

- Auto-save: ``noauto``, ``autoload`` and ``autoloadnew`` disable saving.
  Otherwise ``autosave`` or ``autoshare`` saves.
- Auto-load: ``noauto``, then ``autosave``, then ``autoloadnew``, then ``autoload`` or ``autoshare``.

For example, with ``HISTCONTROL=autosave:autoload``, auto-save does nothing and auto-load only appends.

``HISTORY_AUTOSAVE``
~~~~~~~~~~~~~~~~~~~~

Setting ``HISTORY_AUTOSAVE=1`` behaves like adding ``autoshare`` to ``HISTCONTROL``; ``noauto`` still wins.
These themes default ``HISTORY_AUTOSAVE`` to ``1``:

- ``codeword``
- ``doubletime``
- ``doubletime_multiline``
- ``doubletime_multiline_pyonly``
- ``font``
- ``nwinkler``
- ``nwinkler_random_colors``
- ``pete``
- ``rainbowbrite``

History plugin
~~~~~~~~~~~~~~

The ``history`` plugin sets ``HISTCONTROL`` to ``ignorespace:erasedups:autoshare`` if it is unset,
so enabling it turns on ``autoshare``.
It also enables ``shopt histappend``.
