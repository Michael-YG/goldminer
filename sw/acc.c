#include <linux/module.h>
#include <linux/init.h>
#include <linux/errno.h>
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/platform_device.h>
#include <linux/miscdevice.h>
#include <linux/slab.h>
#include <linux/io.h>
#include <linux/of.h>
#include <linux/of_address.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include "acc.h"

#define DRIVER_NAME0 "sha256acc_1"
#define DRIVER_NAME1 "sha256acc_2"
#define DRIVER_NAME2 "sha256acc_3"

#define HASHW0(x) (x)
#define HASHW1(x) (x+4)
#define HASHW2(x) (x+8)
#define HASHW3(x) (x+12)
#define HASHW4(x) (x+16)
#define HASHW5(x) (x+20)
#define HASHW6(x) (x+24)
#define HASHW7(x) (x+28)
#define HASHW8(x) (x+32)
#define HASHW9(x) (x+36)
#define HASHW10(x) (x+40)
#define HASHW11(x) (x+44)
#define HASHW12(x) (x+48)
#define HASHW13(x) (x+52)
#define HASHW14(x) (x+56)
#define HASHW15(x) (x+60)

#define HASHR0(x) (x)
#define HASHR1(x) (x+4)
#define HASHR2(x) (x+8)
#define HASHR3(x) (x+12)
#define HASHR4(x) (x+16)
#define HASHR5(x) (x+20)
#define HASHR6(x) (x+24)
#define HASHR7(x) (x+28)

#define CONTROLW(x) (x+64) // write only: sw -> hw
#define CONTROLR(x) (x+68) // read only: hw -> sw

struct acc_dev {
    struct resource res; /* Resource: our registers */
    void __iomem *virtbase; /* Where registers can be accessed in memory */
    registers_i_t registers_i;
    registers_o_t registers_o;
    control_signal_t control_signal;
} dev[3];

static void write_hash(registers_i_t * hash_input, unsigned long virtbase) //dev.virtbase
{
    iowrite32(hash_input->r0, HASHW0(virtbase));
    iowrite32(hash_input->r1, HASHW1(virtbase));
    iowrite32(hash_input->r2, HASHW2(virtbase));
    iowrite32(hash_input->r3, HASHW3(virtbase));
    iowrite32(hash_input->r4, HASHW4(virtbase));
    iowrite32(hash_input->r5, HASHW5(virtbase));
    iowrite32(hash_input->r6, HASHW6(virtbase));
    iowrite32(hash_input->r7, HASHW7(virtbase));
    iowrite32(hash_input->r8, HASHW8(virtbase));
    iowrite32(hash_input->r9, HASHW9(virtbase));
    iowrite32(hash_input->r10, HASHW10(virtbase));
    iowrite32(hash_input->r11, HASHW11(virtbase));
    iowrite32(hash_input->r12, HASHW12(virtbase));
    iowrite32(hash_input->r13, HASHW13(virtbase));
    iowrite32(hash_input->r14, HASHW14(virtbase));
    iowrite32(hash_input->r15, HASHW15(virtbase));
}

static void read_hash(registers_o_t * hash_output, unsigned long virtbase)
{
    hash_output->r0 = ioread32(HASHR0(virtbase));
    hash_output->r1 = ioread32(HASHR1(virtbase));
    hash_output->r2 = ioread32(HASHR2(virtbase));
    hash_output->r3 = ioread32(HASHR3(virtbase));
    hash_output->r4 = ioread32(HASHR4(virtbase));
    hash_output->r5 = ioread32(HASHR5(virtbase));
    hash_output->r6 = ioread32(HASHR6(virtbase));
    hash_output->r7 = ioread32(HASHR7(virtbase));
}

static void write_control(unsigned int control, unsigned long virtbase)
{
    iowrite32(control, CONTROLW(virtbase));
}

static void read_control(unsigned int *control, unsigned long virtbase)
{
    *control = ioread32(CONTROLR(virtbase));
}

static long acc_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
{
    registers_arg_t vla;

    switch (cmd) {
    case ACC_WRITE_HASH0:
        if (copy_from_user(&vla.registers_i, (registers_i_t *) arg, sizeof(registers_i_t)))
            return -EACCES;
        write_hash(&vla.registers_i, dev[0].virtbase);
        // write_control(0xffffffff); //start flag
        break;
    case ACC_WRITE_HASH1:
        if (copy_from_user(&vla.registers_i, (registers_i_t *) arg, sizeof(registers_i_t)))
            return -EACCES;
        write_hash(&vla.registers_i, dev[1].virtbase);
        break;
    case ACC_WRITE_HASH2:
        if (copy_from_user(&vla.registers_i, (registers_i_t *) arg, sizeof(registers_i_t)))
            return -EACCES;
        write_hash(&vla.registers_i, dev[2].virtbase);
        break;
    
    case ACC_READ_HASH0:
        read_hash(&vla.registers_o, dev[0].virtbase);
        if (copy_to_user((registers_o_t *) arg, &vla.registers_o, sizeof(registers_o_t)))
            return -EACCES;
        break;
    case ACC_READ_HASH1:
        read_hash(&vla.registers_o, dev[1].virtbase);
        if (copy_to_user((registers_o_t *) arg, &vla.registers_o, sizeof(registers_o_t)))
            return -EACCES;
        break;
    case ACC_READ_HASH2:
        read_hash(&vla.registers_o, dev[2].virtbase);
        if (copy_to_user((registers_o_t *) arg, &vla.registers_o, sizeof(registers_o_t)))
            return -EACCES;
        break;
    case CONTROL_READ0:
        read_control(&vla.control_signal.rr, dev[0].virtbase);
        if(copy_to_user((control_signal_t*) arg, &vla.control_signal.rr, sizeof(control_signal_t)))
            return -EACCES;
        break;
    case CONTROL_READ1:
        read_control(&vla.control_signal.rr, dev[1].virtbase);
        if(copy_to_user((control_signal_t*) arg, &vla.control_signal.rr, sizeof(control_signal_t)))
            return -EACCES;
        break;
    case CONTROL_READ2:
        read_control(&vla.control_signal.rr, dev[2].virtbase);
        if(copy_to_user((control_signal_t*) arg, &vla.control_signal.rr, sizeof(control_signal_t)))
            return -EACCES;
        break;
    case CONTROL_WRITE0:
        if(copy_from_user((&vla.control_signal.rr), (control_signal_t *) arg, sizeof(control_signal_t)))
            return -EACCES;
        write_control(vla.control_signal.rr, dev[0].virtbase);
        break;
    case CONTROL_WRITE1:
        if(copy_from_user((&vla.control_signal.rr), (control_signal_t *) arg, sizeof(control_signal_t)))
            return -EACCES;
        write_control(vla.control_signal.rr, dev[1].virtbase);
        break;
    case CONTROL_WRITE2:
        if(copy_from_user((&vla.control_signal.rr), (control_signal_t *) arg, sizeof(control_signal_t)))
            return -EACCES;
        write_control(vla.control_signal.rr, dev[2].virtbase);
        break;
    default:
        return -EINVAL;
    }
    return 0;
}

static const struct file_operations acc_fops = {
    .owner = THIS_MODULE,
    .unlocked_ioctl = acc_ioctl,
};

static struct miscdevice acc_misc_dev[] = {
    {
        .minor = MISC_DYNAMIC_MINOR,
        .name = DRIVER_NAME0,
        .fops = &acc_fops,
    },
    {
        .minor = MISC_DYNAMIC_MINOR,
        .name = DRIVER_NAME1,
        .fops = &acc_fops,
    },
    {
        .minor = MISC_DYNAMIC_MINOR,
        .name = DRIVER_NAME2,
        .fops = &acc_fops,
    }
};

static int __init acc_probe0(struct platform_device *pdev)
{
    registers_i_t beigh = {0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000};

    int ret;
    char * driver_names[] = {
        DRIVER_NAME0,
        DRIVER_NAME1,
        DRIVER_NAME2,
    };

    ret = misc_register(&acc_misc_dev[0]);

    ret = of_address_to_resource(pdev->dev.of_node, 0, &dev[0].res);
    if(ret){
        ret = -ENODEV;

        goto out_deregister;
    }

    if (request_mem_region(dev[0].res.start, resource_size(&dev[0].res),
			         driver_names[0]) == NULL) {
		ret =-EBUSY;
        goto out_deregister;
	}

    dev[0].virtbase = ioremap(dev[0].res.start, resource_size(&dev[0].res));
    if (dev[0].virtbase == NULL) {
        ret = -ENOMEM;
        pr_info("ioremap failed\n");
        goto out_release_mem;
    }

    write_hash(&beigh, dev[0].virtbase);
    write_control(0x00000000, dev[0].virtbase);

    return 0;

out_release_mem:
    release_mem_region(dev[0].res.start, resource_size(&dev[0].res));
out_deregister:
    misc_deregister(&acc_misc_dev[0]);
    return ret;
}

static int __init acc_probe1(struct platform_device *pdev)
{
    registers_i_t beigh = {0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000};

    int ret;
    char * driver_names[] = {
        DRIVER_NAME0,
        DRIVER_NAME1,
        DRIVER_NAME2,
    };

    ret = misc_register(&acc_misc_dev[1]);

    ret = of_address_to_resource(pdev->dev.of_node, 0, &dev[1].res);
    if(ret){
        ret = -ENODEV;

        goto out_deregister;
    }

    if (request_mem_region(dev[1].res.start, resource_size(&dev[1].res),
			         driver_names[1]) == NULL) {
		ret =-EBUSY;
        goto out_deregister;
	}

    dev[1].virtbase = ioremap(dev[1].res.start, resource_size(&dev[1].res));
    if (dev[1].virtbase == NULL) {
        ret = -ENOMEM;
        pr_info("ioremap failed\n");
        goto out_release_mem;
    }

    write_hash(&beigh, dev[1].virtbase);
    write_control(0x00000000, dev[1].virtbase);

    return 0;

out_release_mem:
    release_mem_region(dev[1].res.start, resource_size(&dev[1].res));
out_deregister:
    misc_deregister(&acc_misc_dev[1]);
    return ret;
}

static int __init acc_probe2(struct platform_device *pdev)
{
    registers_i_t beigh = {0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000};

    int ret;
    char * driver_names[] = {
        DRIVER_NAME0,
        DRIVER_NAME1,
        DRIVER_NAME2,
    };

    ret = misc_register(&acc_misc_dev[2]);

    ret = of_address_to_resource(pdev->dev.of_node, 0, &dev[2].res);
    if(ret){
        ret = -ENODEV;

        goto out_deregister;
    }

    if (request_mem_region(dev[2].res.start, resource_size(&dev[2].res),
			         driver_names[2]) == NULL) {
		ret =-EBUSY;
        goto out_deregister;
	}

    dev[2].virtbase = ioremap(dev[2].res.start, resource_size(&dev[2].res));
    if (dev[2].virtbase == NULL) {
        ret = -ENOMEM;
        pr_info("ioremap failed\n");
        goto out_release_mem;
    }

    write_hash(&beigh, dev[2].virtbase);
    write_control(0x00000000, dev[2].virtbase);

    return 0;

out_release_mem:
    release_mem_region(dev[2].res.start, resource_size(&dev[2].res));
out_deregister:
    misc_deregister(&acc_misc_dev[2]);
    return ret;
}

static int acc_remove0(struct platform_device *pdev)
{
    iounmap(dev[0].virtbase);
    release_mem_region(dev[0].res.start, resource_size(&dev[0].res));
    misc_deregister(&acc_misc_dev[0]);
    return 0;
}
static int acc_remove1(struct platform_device *pdev)
{
    iounmap(dev[1].virtbase);
    release_mem_region(dev[1].res.start, resource_size(&dev[1].res));
    misc_deregister(&acc_misc_dev[1]);
    return 0;
}
static int acc_remove2(struct platform_device *pdev)
{
    iounmap(dev[2].virtbase);
    release_mem_region(dev[2].res.start, resource_size(&dev[2].res));
    misc_deregister(&acc_misc_dev[2]);
    return 0;
}
#ifdef CONFIG_OF
static const struct of_device_id acc_of_match0[] = {
	{ .compatible = "csee4840,sha256acc_1-1.0" },
	{},
};
static const struct of_device_id acc_of_match1[] = {
	{ .compatible = "csee4840,sha256acc_2-1.0" },
	{},
};
static const struct of_device_id acc_of_match2[] = {
	{ .compatible = "csee4840,sha256acc_3-1.0" },
	{},
};
MODULE_DEVICE_TABLE(of, acc_of_match0);
MODULE_DEVICE_TABLE(of, acc_of_match1);
MODULE_DEVICE_TABLE(of, acc_of_match2);
#endif

static struct platform_driver acc_driver0 = {
    .driver = {
        .name = DRIVER_NAME0,
        .owner = THIS_MODULE,
        .of_match_table = of_match_ptr(acc_of_match0),
    },
    .remove = __exit_p(acc_remove0),
};
static struct platform_driver acc_driver1 = {
    .driver = {
        .name = DRIVER_NAME1,
        .owner = THIS_MODULE,
        .of_match_table = of_match_ptr(acc_of_match1),
    },
    .remove = __exit_p(acc_remove1),
};
static struct platform_driver acc_driver2 = {
    .driver = {
        .name = DRIVER_NAME2,
        .owner = THIS_MODULE,
        .of_match_table = of_match_ptr(acc_of_match2),
    },
    .remove = __exit_p(acc_remove2),
};

static int __init acc_init(void)
{
    int ret;
    pr_info("sha256acc: init\n");
    ret = platform_driver_probe(&acc_driver0, acc_probe0);
    if(ret){
        pr_info("sha256acc0: probe failed\n");
        return ret;
    }
    ret = platform_driver_probe(&acc_driver1, acc_probe1);
    if(ret){
        pr_info("sha256acc1: probe failed\n");
        return ret;
    }
    ret = platform_driver_probe(&acc_driver2, acc_probe2);
    if(ret){
        pr_info("sha256acc2: probe failed\n");
        return ret;
    }

    pr_info("sha256acc: probe success for %d devices\n", 3);

    return 0;
}

static void __exit acc_exit(void)
{
    platform_driver_unregister(&acc_driver0);
    platform_driver_unregister(&acc_driver1);
    platform_driver_unregister(&acc_driver2);
    pr_info("sha256acc: exit\n");
    pr_info("sha256acc unregistered for %d matching devices\n", 3);
}

module_init(acc_init);
module_exit(acc_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("mgy");
MODULE_DESCRIPTION("SHA256 Accelerator Driver");
