import tkinter as tk
from tkinter import ttk, messagebox
import mysql.connector
from mysql.connector import Error

DB={"host":"localhost","user":"payroll_app","password":"PayrollDemo@2026!","database":"EmployeePayrollDB"}
TABLES=["DEPARTMENT","DESIGNATION","EMPLOYEE","ATTENDANCE","SALARY_COMPONENT","SALARY","DEDUCTION","PAYROLL","PAYMENT"]

class PayrollUI:
    def __init__(self,root):
        self.root=root
        root.title("Employee Payroll & Statutory Deduction Management System")
        root.geometry("1400x780"); root.minsize(1100,650)
        self.conn=None; self.columns=[]; self.pk=None
        s=ttk.Style()
        try:s.theme_use("clam")
        except:pass
        s.configure("Treeview",rowheight=32,font=("Arial",11))
        s.configure("Treeview.Heading",font=("Arial",11,"bold"),padding=8)
        s.configure("TButton",font=("Arial",10),padding=(12,7))
        self.build(); self.connect()

    def build(self):
        h=tk.Frame(self.root,padx=22,pady=18); h.pack(fill="x")
        tk.Label(h,text="Employee Payroll & Statutory Deduction Management System",font=("Arial",20,"bold")).pack(anchor="w")
        tk.Label(h,text="Database Management System • Live MySQL Records",font=("Arial",11),fg="#666").pack(anchor="w",pady=(5,0))
        self.status=tk.Label(h,text="Connecting to MySQL...",fg="orange"); self.status.pack(anchor="w",pady=(8,0))
        body=tk.Frame(self.root,padx=22,pady=5); body.pack(fill="both",expand=True)
        left=tk.Frame(body,width=235,bd=1,relief="solid",padx=12,pady=12); left.pack(side="left",fill="y",padx=(0,18)); left.pack_propagate(False)
        tk.Label(left,text="DATABASE TABLES",font=("Arial",11,"bold")).pack(anchor="w",pady=(0,10))
        self.lst=tk.Listbox(left,font=("Arial",11),activestyle="none",borderwidth=0,highlightthickness=0)
        self.lst.pack(fill="both",expand=True)
        for t in TABLES:self.lst.insert("end",t)
        self.lst.bind("<<ListboxSelect>>",lambda e:self.load())
        right=tk.Frame(body); right.pack(side="left",fill="both",expand=True)
        tr=tk.Frame(right); tr.pack(fill="x")
        self.title=tk.Label(tr,text="Select a table",font=("Arial",16,"bold")); self.title.pack(side="left")
        self.count=tk.Label(tr,text="",font=("Arial",10),fg="#666"); self.count.pack(side="right")
        b=tk.Frame(right); b.pack(fill="x",pady=(12,10))
        ttk.Button(b,text="VIEW / REFRESH",command=self.load).pack(side="left",padx=(0,8))
        ttk.Button(b,text="INSERT",command=self.insert).pack(side="left",padx=8)
        ttk.Button(b,text="DELETE SELECTED",command=self.delete).pack(side="left",padx=8)
        tf=tk.Frame(right,bd=1,relief="solid"); tf.pack(fill="both",expand=True)
        self.tree=ttk.Treeview(tf,show="headings",selectmode="browse")
        ys=ttk.Scrollbar(tf,orient="vertical",command=self.tree.yview); xs=ttk.Scrollbar(tf,orient="horizontal",command=self.tree.xview)
        self.tree.configure(yscrollcommand=ys.set,xscrollcommand=xs.set)
        self.tree.grid(row=0,column=0,sticky="nsew"); ys.grid(row=0,column=1,sticky="ns"); xs.grid(row=1,column=0,sticky="ew")
        tf.rowconfigure(0,weight=1); tf.columnconfigure(0,weight=1)
        f=tk.Frame(self.root,padx=22,pady=10); f.pack(fill="x")
        tk.Label(f,text="All INSERT fields are editable. Foreign-key rules are still enforced by MySQL.",fg="#777",font=("Arial",9)).pack(side="left")
        tk.Label(f,text="MySQL • EmployeePayrollDB",fg="#777",font=("Arial",9)).pack(side="right")

    def connect(self):
        try:
            self.conn=mysql.connector.connect(**DB)
            if self.conn.is_connected():
                self.status.config(text="✓ Connected to EmployeePayrollDB",fg="green")
                self.lst.selection_set(0); self.load()
        except Error as e:
            self.status.config(text="✗ MySQL connection failed",fg="red")
            messagebox.showerror("MySQL Connection Error",str(e))

    def load(self):
        s=self.lst.curselection()
        if not s:return
        table=self.lst.get(s[0])
        try:
            c=self.conn.cursor(); c.execute(f"SHOW COLUMNS FROM `{table}`"); info=c.fetchall()
            self.columns=[r[0] for r in info]; self.pk=next((r[0] for r in info if r[3]=="PRI"),None)
            c.execute(f"SELECT * FROM `{table}`"); rows=c.fetchall(); c.close()
            self.tree.delete(*self.tree.get_children()); self.tree["columns"]=self.columns
            for col in self.columns:
                self.tree.heading(col,text=col)
                width=190 if any(x in col for x in ("Name","Address","Email")) else 135 if "Date" in col else 125 if col.endswith("_ID") else 150
                self.tree.column(col,width=width,minwidth=90,stretch=False,anchor="center")
            for r in rows:self.tree.insert("", "end", values=["" if v is None else str(v) for v in r])
            self.title.config(text=table); self.count.config(text=f"{len(rows)} record(s)")
        except Error as e:messagebox.showerror("View Error",str(e))

    def insert(self):
        s=self.lst.curselection()
        if not s:return
        table=self.lst.get(s[0])
        try:
            c=self.conn.cursor(); c.execute(f"SHOW COLUMNS FROM `{table}`"); meta=c.fetchall(); c.close()
        except Error as e:messagebox.showerror("Error",str(e)); return
        w=tk.Toplevel(self.root); w.title(f"Insert Record — {table}"); w.geometry("700x700"); w.grab_set()
        tk.Label(w,text=f"Insert Record — {table}",font=("Arial",16,"bold")).pack(anchor="w",padx=20,pady=15)
        tk.Label(w,text="Type values directly. Foreign-key fields are editable too.",fg="#666").pack(anchor="w",padx=20,pady=(0,8))
        cv=tk.Canvas(w,highlightthickness=0); sb=ttk.Scrollbar(w,orient="vertical",command=cv.yview); form=tk.Frame(cv)
        form.bind("<Configure>",lambda e:cv.configure(scrollregion=cv.bbox("all"))); cv.create_window((0,0),window=form,anchor="nw"); cv.configure(yscrollcommand=sb.set)
        cv.pack(side="left",fill="both",expand=True,padx=(20,0)); sb.pack(side="right",fill="y",padx=(0,20))
        entries={}
        for i,row in enumerate(meta):
            col,typ,null,key,default,extra=row
            tk.Label(form,text=col,font=("Arial",10,"bold")).grid(row=i,column=0,sticky="w",padx=10,pady=8)
            if "auto_increment" in (extra or ""):
                tk.Label(form,text="AUTO GENERATED",fg="#777").grid(row=i,column=1,sticky="w",padx=10); continue
            e=tk.Entry(form,width=48); e.grid(row=i,column=1,sticky="ew",padx=10); entries[col]=e
            if default is not None:e.insert(0,str(default))
            if null=="YES":tk.Label(form,text="optional",fg="#888").grid(row=i,column=2,sticky="w")
        def save():
            try:
                fields=[]; vals=[]
                for row in meta:
                    col,typ,null,key,default,extra=row
                    if "auto_increment" in (extra or ""):continue
                    v=entries[col].get().strip()
                    if v=="":
                        if null=="YES" or default is not None:v=None
                        else:messagebox.showwarning("Missing Value",f"Please enter {col}.",parent=w);return
                    fields.append(col);vals.append(v)
                sql=f"INSERT INTO `{table}` ({', '.join('`'+x+'`' for x in fields)}) VALUES ({', '.join(['%s']*len(vals))})"
                c=self.conn.cursor();c.execute(sql,vals);self.conn.commit();c.close()
                messagebox.showinfo("Success",f"Record inserted into {table}.",parent=w);w.destroy();self.load()
            except Error as e:
                self.conn.rollback()
                messagebox.showerror("Insert Error","Record could not be inserted.\n\nCheck IDs and values.\n\n"+str(e),parent=w)
        ttk.Button(w,text="INSERT RECORD",command=save).pack(pady=15)

    def delete(self):
        s=self.lst.curselection()
        if not s:return
        if not self.pk:messagebox.showerror("Delete Error","No primary key detected.");return
        item=self.tree.selection()
        if not item:messagebox.showwarning("Select Row","Please select a row first.");return
        table=self.lst.get(s[0]); vals=self.tree.item(item[0],"values"); pkv=vals[self.columns.index(self.pk)]
        if not messagebox.askyesno("Confirm Delete",f"Delete this record?\n\n{self.pk} = {pkv}"):return
        try:
            c=self.conn.cursor();c.execute(f"DELETE FROM `{table}` WHERE `{self.pk}`=%s",(pkv,));self.conn.commit();c.close()
            messagebox.showinfo("Success","Record deleted successfully.");self.load()
        except Error as e:
            self.conn.rollback();messagebox.showerror("Delete Error","MySQL could not delete this record.\n\nA related table may reference it.\n\n"+str(e))

if __name__=="__main__":
    root=tk.Tk(); PayrollUI(root); root.mainloop()
