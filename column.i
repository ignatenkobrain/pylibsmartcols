/* column.i
 *
 * Copyright (C) 2015 Igor Gnatenko <i.gnatenko.brain@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

PROPERTY(Column, trunc, bool)
PROPERTY(Column, tree, bool)
PROPERTY(Column, right, bool)
PROPERTY(Column, strict_width, bool)
PROPERTY(Column, noextremes, bool)
#ifdef FLAGS_HIDDEN
PROPERTY(Column, hidden, bool)
#endif
PROPERTY(Column, name, const char *)
PROPERTY(Column, color, const char *)
PROPERTY(Column, whint, double)

%inline %{

class Column {
    private:
        struct libscols_column *cl = NULL;
        void set_flag(int flag, bool v) {
            int flags = scols_column_get_flags(this->cl);
            bool current = (bool) (flags & flag);
            if (!current && v)
                scols_column_set_flags(this->cl, flags | flag);
            else if (current && !v)
                scols_column_set_flags(this->cl, flags ^ flag);
        }
    public:
        Column(const char *name, double whint = -1, bool trunc = false, bool tree = false, bool right = false, bool strict_width = false, bool noextremes = false, bool hidden = false) {
            this->cl = scols_new_column();
            this->name(name);
            if (whint >= 0)
                this->whint(whint);
            this->trunc(trunc);
            this->tree(tree);
            this->right(right);
            this->strict_width(strict_width);
            this->noextremes(noextremes);
#ifdef FLAGS_HIDDEN
            this->hidden(hidden);
#endif
        }
        ~Column() {
            scols_unref_column(this->cl);
        }
        libscols_column *get_struct() {
            return this->cl;
        }

        bool trunc() const {
            return (bool) scols_column_is_trunc(this->cl);
        }
        void trunc(bool v) {
            this->set_flag(SCOLS_FL_TRUNC, v);
        }

        bool tree() const {
            return (bool) scols_column_is_tree(this->cl);
        }
        void tree(bool v) {
            this->set_flag(SCOLS_FL_TREE, v);
        }

        bool right() const {
            return (bool) scols_column_is_right(this->cl);
        }
        void right(bool v) {
            this->set_flag(SCOLS_FL_RIGHT, v);
        }

        bool strict_width() const {
            return (bool) scols_column_is_strict_width(this->cl);
        }
        void strict_width(bool v) {
            this->set_flag(SCOLS_FL_STRICTWIDTH, v);
        }

        bool noextremes() const {
            return (bool) scols_column_is_noextremes(this->cl);
        }
        void noextremes(bool v) {
            this->set_flag(SCOLS_FL_NOEXTREMES, v);
        }

#ifdef FLAGS_HIDDEN
        bool hidden() const {
            return (bool) scols_column_is_hidden(this->cl);
        }
        void hidden(bool v) {
            this->set_flag(SCOLS_FL_HIDDEN, v);
        }
#endif
        const char *name() const {
            return scols_cell_get_data(scols_column_get_header(this->cl));
        }
        void name(const char *name) {
            scols_cell_set_data(scols_column_get_header(this->cl), name);
        }

        const char *color() const {
            return scols_column_get_color(this->cl);
        }
        void color(const char *color) {
            HANDLE_RC(scols_column_set_color(this->cl, color));
        }

        double whint() const {
            return scols_column_get_whint(this->cl);
        }
        void whint(double whint) {
            HANDLE_RC(scols_column_set_whint(this->cl, whint));
        }
};

%}
